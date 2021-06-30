import statistics
import pandas as pd
import matplotlib.pyplot as plt
import utility
import re

# These are the "Tableau 20" colors as RGB.    
tableau20 = [#(31, 119, 180), (174, 199, 232), (255, 127, 14), (255, 187, 120),    
             #(44, 160, 44), (152, 223, 138), (214, 39, 40), (255, 152, 150),    
             #(148, 103, 189), (197, 176, 213), (140, 86, 75), (196, 156, 148),    
             #(227, 119, 194), (247, 182, 210), (127, 127, 127), (199, 199, 199),    
             (188, 189, 34), (219, 219, 141), (23, 190, 207), (158, 218, 229)]    
  
# Scale the RGB values to the [0, 1] range, which is the format matplotlib accepts.    
for i in range(len(tableau20)):    
    r, g, b = tableau20[i]    
    tableau20[i] = (r / 255., g / 255., b / 255.)

# Define Regex Constants
regex_GFAP = ".*GFAP.*roi_[0-9]+.*"
regex_IgG = ".*IgG.*roi_[0-9]+.*"
regex_CD68 = ".*CD68.*roi_[0-9]+.*"

regex_GFAP_background = ".*GFAP.*background.*"
regex_IgG_background = ".*IgG.*background.*"
regex_CD68_background = ".*CD68.*background.*"

#file_path = '/content/'+ <File_Name.csv>
# Conventions: Results_mBYXX_Y_Z_<side>_<Marker>_DDMMYY_HHMMSS.csv
#          XX: Animal Number
#           Y: Slide Number
#           Z: Slice Number

def load_fluorescence_data(file_path):
  headers = ['Label','Area','Mean','StdDev']
  df = pd.read_csv(file_path,names=headers)
  return df

def load_cell_count_data(file_path):
  #headers = ['Slice','Count','AverageSize','Area', "Mean"]
  df = pd.read_csv(file_path)
  return df

def plot_intensity_scatter(marker, x, y, background):
  # Extract Distance from Implant
  x = x.apply(lambda x: x.rpartition('_')[2])
  y = y.astype(float)

  # Plot
  plt.scatter(x,y)
  plt.axhline(y=float(background[0]), color='r', linestyle='-')
  plt.xlabel('Distance from Implant (um)')
  plt.ylabel('Absolute Pixel Intensity')
  plt.title(marker)
  plt.show()

def plot_intensity_profile(marker, x, y, background):
  # Extract Distance from Implant
  x = x.apply(lambda x: x.rpartition('_')[2])
  y = y.astype(float)

  min = float(background[0])
  max = y.max()
  mean = statistics.mean([min, y.mean()])
  y = (y - mean)/(max - min)

  # Plot
  plt.plot(x,y)
  plt.xlabel('Distance from Implant (um)')
  plt.ylabel('Normalized Fluorescent Intensity')
  plt.title(marker)
  plt.show()

def plot_cell_count_profile(filename, df):
  step_size = int(utility.get_config_parameter('STEP'))

  y = df['Count'].astype(float).values
  x = range(step_size, step_size*(len(y)+1), step_size)
  area = df['Total Area'].astype(float).values
  y = y*(1/area)

  # Plot
  # Remove the plot frame lines. They are unnecessary chartjunk.    
  ax = plt.axes()   
  ax.spines["top"].set_visible(False)    
  ax.spines["bottom"].set_visible(False)    
  ax.spines["right"].set_visible(False)    
  ax.spines["left"].set_visible(False) 

  plt.plot(x, y, 'o-', lw=2.5, color=tableau20[3])   

  plt.xlabel('Distance from Implant (um)', labelpad=20)
  plt.xticks(x)
  plt.ylabel('Normalized Cell Count', labelpad=20)

  file_parts = filename.split('_')
  animal_id = file_parts[1]
  slide = file_parts[2]
  slice = file_parts[3]

  plt.gcf().text(0.02, 0.02,
    "\nSpecies: Mouse; ID: "+animal_id+"; Slide: "+slide[-1]+"; Slice: "+slice[-1]+""
    "\nProbe: 20 um sharp tip tungsten wire; AP: -2.5 mm; ML: 1.5 mm; Hemisphere: Left"
    "\nSource Code: https://github.com/mpotta/ihc-analysis", fontsize=7) 

  plt.title("Percentage of Background Cell Count", fontstyle='italic')
  plt.grid(linestyle="--", lw=0.5, color="black", alpha=0.3)
  plt.tight_layout(pad=4)

  plt.show()

  save_plot("NormalizedCellCount", filename)

def plot_fluorescence_profile(filename, df):
  background_GFAP = df[df['Label'].str.contains(regex_GFAP_background, flags=re.IGNORECASE)]
  df_GFAP = df[df['Label'].str.contains(regex_GFAP, flags=re.IGNORECASE)]
  background_IgG = df[df['Label'].str.contains(regex_IgG_background, flags=re.IGNORECASE)]
  df_IgG = df[df['Label'].str.contains(regex_IgG, flags=re.IGNORECASE)]
  background_CD68 = df[df['Label'].str.contains(regex_CD68_background, flags=re.IGNORECASE)]
  df_CD68 = df[df['Label'].str.contains(regex_CD68, flags=re.IGNORECASE)]

  # Remove the plot frame lines. They are unnecessary chartjunk.    
  ax = plt.axes()   
  ax.spines["top"].set_visible(False)    
  ax.spines["bottom"].set_visible(False)    
  ax.spines["right"].set_visible(False)    
  ax.spines["left"].set_visible(False)    
    
  # Ensure that the axis ticks only show up on the bottom and left of the plot.    
  # Ticks on the right and top of the plot are generally unnecessary chartjunk.    
  ax.get_xaxis().tick_bottom()    
  ax.get_yaxis().tick_left()

  x = df_GFAP['Label'].apply(lambda x: x.rpartition('_')[2])
  y = df_GFAP['Mean'].astype(float)

  min = float(background_GFAP['Mean'][0])
  max = y.max()
  y = (y - min)/(max - min)
  plt.plot(x, y, 'o-', lw=2.5, color=tableau20[0], label="GFAP")

  x = df_IgG['Label'].apply(lambda x: x.rpartition('_')[2])
  y = df_IgG['Mean'].astype(float)

  min = float(background_IgG['Mean'][0])
  max = y.max()
  y = (y - min)/(max - min)

  plt.plot(x, y, 'o-', lw=2.5, color=tableau20[1], label="IgG")

  x = df_CD68['Label'].apply(lambda x: x.rpartition('_')[2])
  y = df_CD68['Mean'].astype(float)

  min = float(background_CD68['Mean'][0])
  max = y.max()
  y = (y - min)/(max - min)

  plt.plot(x, y, 'o-', lw=2.5, color=tableau20[2], label="CD68")

  plt.xlabel('Distance from Implant (um)', labelpad=20)
  plt.ylabel('Normalized Fluorescence', labelpad=20)

  for line, name in zip(ax.lines, ['GFAP', 'IgG', 'CD68']):
    y = line.get_ydata()[-1]
    ax.annotate(name, xy=(1,y), xytext=(6,0), color=line.get_color(), 
                xycoords = ax.get_yaxis_transform(), textcoords="offset points",
                size=10, va="center")

  file_parts = filename.split('_')
  animal_id = file_parts[1]
  slide = file_parts[2]
  slice = file_parts[3]

  plt.gcf().text(0.02, 0.02,
    "\nSpecies: Mouse; ID: "+animal_id+"; Slide: "+slide[-1]+"; Slice: "+slice[-1]+""
    "\nProbe: 20 um sharp tip tungsten wire; AP: -2.5 mm; ML: 1.5 mm; Hemisphere: Left"
    "\nSource Code: https://github.com/mpotta/ihc-analysis", fontsize=7) 

  plt.title("Normalized Fluorescence Intensity across Immune Markers", fontstyle='italic')
  plt.grid(linestyle="--", lw=0.5, color="black", alpha=0.3)
  plt.tight_layout(pad=4)
  plt.show()

  save_plot("NormalizedFluorescence", filename)

def plot_GFAP(df):

  background_GFAP = df[df['Label'].str.contains(regex_GFAP_background, flags=re.IGNORECASE)]
  df_GFAP = df[df['Label'].str.contains(regex_GFAP, flags=re.IGNORECASE)]

  plot_intensity_scatter("GFAP", df_GFAP['Label'], df_GFAP['Mean'], background_GFAP['Mean'])
  plot_intensity_profile("GFAP", df_GFAP['Label'], df_GFAP['Mean'], background_GFAP['Mean'])

def plot_IgG(df):

  background_IgG = df[df['Label'].str.contains(regex_IgG_background, flags=re.IGNORECASE)]
  df_IgG = df[df['Label'].str.contains(regex_IgG, flags=re.IGNORECASE)]

  plot_intensity_scatter("IgG", df_IgG['Label'], df_IgG['Mean'], background_IgG['Mean'])
  plot_intensity_profile("IgG", df_IgG['Label'], df_IgG['Mean'], background_IgG['Mean'])

def plot_CD68(df):
  
  background_CD68 = df[df['Label'].str.contains(regex_CD68_background, flags=re.IGNORECASE)]
  df_CD68 = df[df['Label'].str.contains(regex_CD68, flags=re.IGNORECASE)]

  plot_intensity_scatter("CD68", df_CD68['Label'], df_CD68['Mean'], background_CD68['Mean'])
  plot_intensity_profile("CD68", df_CD68['Label'], df_CD68['Mean'], background_CD68['Mean'])

def save_plot(name, marker):
  if utility.get_config_parameter('SAVE_PLOTS'):
    plt.savefig(utility.get_config_parameter('DIRECTORY').strip('\'') + "/"+ name +"_" + marker + ".png")