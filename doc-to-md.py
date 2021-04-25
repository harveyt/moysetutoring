#!/usr/bin/python2
import sys

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

    def process_div(self, style, func):
        div_begin = '<div custom-style="{}">'.format(style)
        div_end = '</div>'
        new_lines = []
        div_lines = []
        in_div = False
        for line in self.lines:
            if not in_div:
                if not line.startswith(div_begin):
                    if line == "":
                        continue
                    new_lines.append(line)
                    continue
                in_div = True
                div_lines = []
            else:
                if not line.startswith(div_end):
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
        self.apply_filter(lambda l: not l.startswith('<img src="'))
        
    def _filter_poetry_block(self, lines):
        result = []
        for line in lines:
            line = line.strip()
            if line == "":
                continue
            result.append('{}  '.format(line))
        return result

    def filter_poetry(self):
        self.process_div("Poetry", self._filter_poetry_block)
    
    def filter_default(self):
        self.process_div("Default", lambda lines: [""])

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
        self.write()

d = Doc()
d.process()
sys.exit(0)

