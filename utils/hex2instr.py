import sys

text = sys.argv[1]

binary = '{:016b}'.format(int(text, 16))
print(binary)
