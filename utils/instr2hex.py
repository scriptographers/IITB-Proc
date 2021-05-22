import sys

text = sys.argv[1]

tokens = text.split(" ")

op = tokens[0]

if op in ["ADD", "ADC", "ADZ", "NDU", "NDC", "NDZ"]:

    if op[0] == "A":
        op_bits = "0000"
    else:
        op_bits = "0010"

    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    RC = int(tokens[3][1])

    RA_bits = "{0:03b}".format(RA)
    RB_bits = "{0:03b}".format(RB)
    RC_bits = "{0:03b}".format(RC)

    CZ = tokens[-1]

    binary = op_bits + RA_bits + RB_bits + RC_bits + "0" + CZ

elif op in ["ADI", "LW", "SW", "BEQ"]:

    if op == "ADI":
        op_bits = "0001"
    elif op == "LW":
        op_bits = "0100"
    elif op == "SW":
        op_bits = "0101"
    else:
        op_bits = "1100"

    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    IMM = int(tokens[3])

    RA_bits  = "{0:03b}".format(RA)
    RB_bits  = "{0:03b}".format(RB)
    IMM_bits = "{0:03b}".format(IMM)

    binary = op_bits + RA_bits + RB_bits + IMM_bits

elif op == "JLR":
    op_bits = "1001"
    RA = int(tokens[1][1])
    RB = int(tokens[2][1])
    RA_bits  = "{0:03b}".format(RA)
    RB_bits  = "{0:03b}".format(RB)
    binary = op_bits + RA_bits + RB_bits + "0"*6

elif op in ["LA", "SA"]:

    if op == "LA":
        op_bits = "0110"
    elif op == "SA":
        op_bits = "0111"

    RA = int(tokens[1][1])
    RA_bits  = "{0:03b}".format(RA)
    binary = op_bits + RA_bits + "0"*9

elif op in ["LHI", "JAL"]:

    if op == "LHI":
        op_bits = "0011"
    elif op == "JAL":
        op_bits = "1000"

    RA = int(tokens[1][1])
    IMM = int(tokens[2])

    RA_bits  = "{0:03b}".format(RA)
    IMM_bits = "{0:03b}".format(IMM)

    binary = op_bits + RA_bits + IMM_bits


hexa = str(hex(int(binary, 2)))

hexa = 'x"' + hexa[2:] + '"'

print(hexa)

