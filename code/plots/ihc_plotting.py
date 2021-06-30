import ihc_plotting_library as ihc
import utility
import os

def main():

    input_directory_path = utility.get_config_parameter('DIRECTORY').strip('\'')

    for filename in os.listdir(input_directory_path):
        if filename.endswith(".csv"):
            if filename.startswith("Results"):
                df_fluorescence = ihc.load_fluorescence_data(os.path.join(input_directory_path, filename))
                ihc.plot_fluorescence_profile(filename, df_fluorescence)
            if filename.startswith("Summary"):
                df_cell_count = ihc.load_cell_count_data(os.path.join(input_directory_path, filename))
                ihc.plot_cell_count_profile(filename, df_cell_count)

if __name__ == "__main__":
    main()