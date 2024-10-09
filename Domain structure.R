# Load required libraries
library(ggtree)
library(ggplot2)
library(treeio)
library(tidytree)
library(dplyr)
library(ggrepel)
library(hrbrthemes)
library(gggenes)  # Make sure this is loaded for geom_gene_arrow()
tree <- treeio::read.newick(file = "/Users/macbook/Documents/gene family 2/tree/sme_pep.muscle.treefile", node.label = "support")
as_tibble(tree)
get_taxa_name(ggtree(tree) ) -> tree.sort.id
domain <- read.table(file = "Pfam_scan.out", comment.char = "#", header = F) %>%
  dplyr::select(1,2,3,6,7) %>%
  dplyr::mutate(V1 = factor(V1, levels = rev(tree.sort.id), ordered = T))
#Visualization
domain_p <- ggplot(domain, aes(xmin = V2, xmax = V3, y = V1, fill = V7)) +
  geom_gene_arrow(arrowhead_width = unit(0, "mm"),
                  arrowhead_height = unit(1, "mm")) +
  labs(x = "", y = "") + 
  ggtitle(label = "Domain Analysis") + 
  scale_fill_manual(values = c('#33a02c','#fdbf6f'),
                    name = "Domain") +
  theme_genes() + 
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    legend.background = element_rect(color = "#969696", fill = "#d9d9d9"),
    plot.title = element_text(hjust = 0.5),
    panel.grid.major.y = element_line(color = "black", size = 0.8),
    panel.grid.minor.y = element_line(color = "black", size = 0.05),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(size = 15, face = "bold"),  # Increase x-axis text size
    axis.ticks.x = element_line(size =0.7),  # Make x-axis ticks thicker
    axis.ticks.length = unit(0.25, "cm")  # Make x-axis ticks longer
  )

# Display the plot
print(domain_p)

# Save the plot
ggsave("domain structure.pdf", domain_p, width = 15, height = 18, limitsize = FALSE)
