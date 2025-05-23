# Quantifying Cell Puncta in Immunofluorescence Images

This repository contains an R script to detect and count punctate fluorescent structures—such (for instance, PML nuclear bodies) — in immunofluorescence microscopy images. 

## Description

Quantifying fluorescent puncta is essential in many cell biology and virology studies, particularly in the context of protein localization, virus-host interactions, or stress granule formation. This script helps you:
- Segment grayscale images based on brightness threshold
- Apply size filters to avoid counting background noise or artifacts
- Label and count distinct puncta within the image field

## Requirements:

- R (version ≥ 4.0)
- Bioconductor
- EBImage

### To install the necessary R packages:

```R
install.packages("BiocManager")
BiocManager::install("EBImage")
```

### Load and Run the Script

```R
library(EBImage)
```

### Set image path


```R
image_path <- 'example.jpg'  # replace with your image path
image <- readImage(image_path)
```

### Convert to grayscale if needed

```R
if (length(dim(image)) == 3) {
  image <- channel(image, "gray")
}
```

### ---- Adjustable Parameters ----


```R
manual_threshold <- NULL   # Use NULL to apply automatic Otsu thresholding
min_size <- 10             # Minimum spot size in pixels
max_size <- 1000           # Maximum spot size in pixels
```

### Thresholding


```R
threshold_value <- if (is.null(manual_threshold)) otsu(image) else manual_threshold
binary_image <- image > threshold_value
```

### Label connected components

```R
labeled_image <- bwlabel(binary_image)
```

### Extract area features

```R
features <- computeFeatures.shape(labeled_image)
```

### Apply size filter

```R
valid_indices <- which(features[,"s.area"] >= min_size & features[,"s.area"] <= max_size)
filtered_labeled <- rmObjects(labeled_image, setdiff(1:max(labeled_image), valid_indices))
```

### Count and display

```R
spot_count <- max(filtered_labeled)
display(colorLabels(filtered_labeled), method = "raster")
cat("Detected puncta:", spot_count, "\n")
```

## Example Image

The repository includes an example file: example.jpg. This image shows human fibroblasts stained with:
- Primary antibody: anti-PML (rabbit)
- Secondary antibody: Rhodamine Red-X-conjugated goat anti-rabbit IgG (H+L), Jackson ImmunoResearch, code 111-295-144

When analyzed with the default script settings, the script returns: "Detected puncta: 30"
If you get this result, your installation and setup are working correctly.

## Notes

If your images contain high background noise, bright artifacts, or non-specific fluorescence (e.g., debris or uneven illumination), you can manually mask or crop out those regions before running the analysis.

An effective method is to open the image in Paint/ImageJ or another editor and replace noisy regions with a background-matching color (e.g., black). Save and re-run the script on the modified image.

You can also adjust:
- manual_threshold: set a fixed value (e.g., 0.2) instead of using Otsu
- min_size and max_size: to ignore very small or large artifacts

## Attribution

This script was adapted and extended from an educational tutorial titled “Counting and Identifying Stained Cells Step by Step”, originally published on the [R for Biochemists blog](https://rforbiochemists.blogspot.com/2016/05/counting-and-identifying-stained-cells.html) by Dr. Paul Brennan (Cardiff University). The original script demonstrated the use of the EBImage package for basic cell segmentation and quantification using Otsu thresholding and connected component labeling in R.

Extended by: Maxim Rodzkin