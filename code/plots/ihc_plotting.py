import ihc_plotting_library as ihc

def main():
    file_path_fluorescence = '/Users/meghanapotta/Documents/My NSC/Short Project I/Processed/mBY15_SpinningDisc/output/Results_mBY15_Slide2_Slice4_2046.csv'
    df_fluorescence = ihc.load_fluorescence_data(file_path_fluorescence)
    
    ihc.plot_GFAP(df_fluorescence) # Red; GFAP; Astrocytes
    plot_IgG(df_fluorescence) # Green; IgG; BBB
    plot_CD68(df_fluorescence) # Blue; CD68; Glia

    #file_path_cell_count = ''
    #df_cell_count = load_cell_count_data()

if __name__ == "__main__":
    main()