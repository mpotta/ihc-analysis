import ihc_plotting_library as ihc
import utility
import os

def main():

    input_directory_path = utility.get_config_parameter('DIRECTORY').strip('\'')

    for filename in os.listdir(input_directory_path):
        if filename.endswith(".csv"):
            df_fluorescence = ihc.load_fluorescence_data(os.path.join(input_directory_path, filename))

            ihc.plot_GFAP(df_fluorescence) # Red; GFAP; Astrocytes
            ihc.plot_IgG(df_fluorescence) # Green; IgG; BBB
            ihc.plot_CD68(df_fluorescence) # Blue; CD68; Glia

if __name__ == "__main__":
    main()