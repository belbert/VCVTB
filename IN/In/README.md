
- This folder should include the combined XX.idf files for initializing AFN calculations.
- XX.py files and a Runfile.txt file are created by executing CreateRuns.py in the parent directory.
- Runfile.txt contains all XX.py files that will be executed in simulation order.
- An example XX.idf file, XX.py file and a runfile.txt is included
- To start simulations execute ParallelRun.py in the parent directory.
- You can skip simulations by marking them as a comment in the Runfile.txt files using a #. This only works before a simulation is started.

You can follow the simulations by using the "htop" command in a terminal window.
's-tui' is a useful tool to monitor your hardware while executing.

