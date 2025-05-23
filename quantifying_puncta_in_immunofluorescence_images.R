# Install and load required packages
if (!requireNamespace("EBImage", quietly = TRUE)) {
  install.packages("BiocManager")
  BiocManager::install("EBImage")
}
library(EBImage)

# Load image
image_path <- 'example.jpg'
image <- readImage(image_path)

# Convert to grayscale if RGB
if (length(dim(image)) == 3) {
  image <- channel(image, "gray")
}

# ----------- PARAMETERS TO ADJUST --------------
manual_threshold <- NULL    # Set to NULL to use Otsu; otherwise, value between 0 and 1 (e.g., 0.2)
min_size <- 10              # Minimum area (in pixels) for valid puncta
max_size <- 1000            # Maximum area (in pixels) for valid puncta
# -----------------------------------------------

# Apply thresholding
threshold_value <- if (is.null(manual_threshold)) otsu(image) else manual_threshold
binary_image <- image > threshold_value

# Label connected regions (spots)
labeled_image <- bwlabel(binary_image)

# Measure features (e.g., area)
features <- computeFeatures.shape(labeled_image)

# Filter spots based on size
valid_indices <- which(features[,"s.area"] >= min_size & features[,"s.area"] <= max_size)

# Create filtered labeled image
filtered_labeled <- rmObjects(labeled_image, setdiff(1:max(labeled_image), valid_indices))

# Count remaining spots
spot_count <- max(filtered_labeled)

# Show result
display(colorLabels(filtered_labeled), method = "raster")

# Print count
cat("Detected puncta:", spot_count, "\n")
