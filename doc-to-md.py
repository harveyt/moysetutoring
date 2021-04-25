#!/usr/bin/python2
import sys
import re

class Doc:
    def __init__(self):
        self.infile = sys.stdin
        self.outfile = sys.stdout
        self.lines = []

    def read(self):
        self.lines = []        
        for line in self.infile.readlines():
            line = line.rstrip('\r\n')
            self.lines.append(line)

    def write(self):
        for line in self.lines:
            self.outfile.write(line)
            self.outfile.write('\n')

    def apply_filter(self, func):
        self.lines = list(filter(func, self.lines))

    def process_div(self, style, func,
                    drop_empty_lines=False,
                    start_re='',
                    start_repl=''):
        div_tag = '<div custom-style="{}">'.format(style)
        div_begin = re.compile('{}{}'.format(start_re, div_tag))
        div_end = '</div>'
        new_lines = []
        div_lines = []
        in_div = False
        start_text = ""
        for line in self.lines:
            if not in_div:
                m = div_begin.match(line)
                if not m:
                    if drop_empty_lines and line == "":
                        continue
                    new_lines.append(line)
                    continue
                if start_re != '' and start_repl != '':
                    # Extract the matching div begin text and do start_repl on start_re
                    # portion
                    start_matching = m.group(0)
                    start_matching = start_matching.replace(div_tag, '')
                    start_text = re.sub(start_re, start_repl, start_matching)
                else:
                    start_text = ""
                in_div = True
                div_lines = []
            else:
                if not line.startswith(div_end):
                    if start_text != "":
                        line = start_text + line
                        start_text = ""
                    div_lines.append(line)
                    continue
                in_div = False
                filtered = func(div_lines)
                if filtered:
                    new_lines.extend(filtered)
        self.lines = new_lines
        
    def remove_headers(self):
        self.apply_filter(lambda l: not l.startswith("# "))

    def remove_images(self):
        for i, line in enumerate(self.lines):
            if '<img src=' in line:
                self.lines[i] = re.sub('<img src=.*/>', '', line)
        
    def _filter_poetry_block(self, lines):
        result = []
        for line in lines:
            line = line.strip()
            if line == "":
                continue
            result.append('{}  '.format(line))
        return result

    def filter_poetry(self):
        self.process_div("Poetry", self._filter_poetry_block,
                         drop_empty_lines=True)

    def _filter_default(self, lines):
        result = []
        for line in lines:
            line = line.strip()
            if line == "":
                continue
            result.append(line)
        if len(result) == 0:
            return [""]
        if len(result) == 1 and result[0] == "\342\235\246":
            return ['<p style="text-align: center;">', "\342\235\246", '</p>']
        return result
        
    def filter_default(self):
        self.process_div("Default", self._filter_default)

    def _filter_body(self, lines):
        result = []
        for line in lines:
            result.append(line)
        if len(result) > 0:
            result.insert(0, '')
        return result
        
    def filter_body(self):
        self.process_div("Body", self._filter_body)

    def filter_footnote(self):
        self.process_div("Footnote", self._filter_body,
                         start_re=r'(\[\d*\] )',
                         start_repl=r'\1')
        
    def filter_poetry_post(self):
        # Remove the end spaces at end of poetry block.
        for i, line in enumerate(self.lines):
            if line.strip() == "" and i > 0:
                if self.lines[i-1].strip() != "":
                    self.lines[i-1] = self.lines[i-1].rstrip()

    def process(self):
        self.read()
        self.remove_headers()
        self.remove_images()
        self.filter_poetry()
        self.filter_default()
        self.filter_poetry_post()
        self.filter_body()
        self.filter_footnote()
        self.write()

d = Doc()
d.process()
sys.exit(0)

