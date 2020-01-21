import numpy as np
def load_C_output(filename):
    with open(filename, 'rb') as f:
        contents = f.read()
    state = np.frombuffer(contents, dtype=np.float64)
    state = state.reshape(3, int(state.shape[0]/3))
    return state
