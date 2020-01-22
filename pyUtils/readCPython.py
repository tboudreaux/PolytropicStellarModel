import numpy as np
def load_C_output(filename):
    """Open the file as a byte string

    Positional Arguments:
        filename -- path to binary file to read
    Returns -> state:
        state -- 2D Numpy array containing [xi, theta, dtheta/dxi]

    """
    with open(filename, 'rb') as f:
        contents = f.read()
    # Read the bytes as a c type double
    state = np.frombuffer(contents, dtype=np.float64)

    # Reshape to the known shape of the data (a 2D 3xn list)
    # Using totalsize = 3*n, we know total size so we can
    # find n
    state = state.reshape(3, int(state.shape[0]/3))
    return state
