# Load necessary library
library(ggplot2)

# Read the data
edger_results <- read.csv("edger.csv")

# Filter significant genes
significant_genes <- subset(edger_results, FDR < 0.05)

# Set the output file
png("volcano.png", width = 800, height = 600)

# Volcano Plot
ggplot(edger_results, aes(x = log2FoldChange, y = -log10(PValue))) +
  geom_point(alpha = 0.5, color = "grey") +
  geom_point(data = significant_genes, aes(x = log2FoldChange, y = -log10(PValue)), color = "red", alpha = 0.7) +
  geom_hline(yintercept = -log10(0.05), color = "blue", linetype = "dashed", size = 0.8) +
  geom_vline(xintercept = c(-1, 1), color = "green", linetype = "dashed", size = 0.8) +
  labs(
    x = "Log2 Fold Change",
    y = "-Log10(P-Value)",
    title = "Volcano Plot of Differential Expression"
  ) +
  theme_minimal()

# Close the device
dev.off()
