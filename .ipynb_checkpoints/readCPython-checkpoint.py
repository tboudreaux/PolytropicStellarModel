import numpy as np
def load_C_output(filename):
    with open(filename, 'rb') as f:
        line_one = f.readline()
        remainder = f.read()
    line_one = line_one.decode("utf-8")
    line_one = [float(x.rstrip()) for x in line_one.split(',')]
    xi = np.arange(line_one[0], line_one[1], line_one[2])
    theta = np.frombuffer(remainder, dtype=np.float64)
    return xi, theta
    
    
