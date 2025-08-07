#Kruskall-Wallis 

# Variance comparison
pairwise_variance <- function(data, group_col, value_col) {
  groups <- unique(data[[group_col]])
  comparisons <- combn(groups, 2, simplify = FALSE)
  p_values <- sapply(comparisons, function(pair) {
    group1 <- data[data[[group_col]] == pair[1], value_col]
    group2 <- data[data[[group_col]] == pair[2], value_col]
    test <- var.test(group1, group2)  # Test F per confronto di varianze
    return(test$p.value)
  })
  # BH correction
  p_adjusted <- p.adjust(p_values, method = "BH")
  result <- data.frame(
    comparison = sapply(comparisons, function(x) paste(x, collapse = " vs ")),
    p_value = p_values,
    p_adjusted = p_adjusted
  )
  return(result)
}



#AVAg

#10 years solution

sol_AvAg_10_anni = read.csv('soluzioni_AvAg_10anni.csv',dec=",",sep=';',header=FALSE,row.names=1)
sol_AvAg_10_anni_df = data.frame(valore = c(t(sol_AvAg_10_anni[1,]),t(sol_AvAg_10_anni[2,]),t(sol_AvAg_10_anni[3,]),t(sol_AvAg_10_anni[4,]),t(sol_AvAg_10_anni[5,]),t(sol_AvAg_10_anni[6,]),t(sol_AvAg_10_anni[7,]),t(sol_AvAg_10_anni[8,]),t(sol_AvAg_10_anni[9,]),t(sol_AvAg_10_anni[10,]),t(sol_AvAg_10_anni[11,]),t(sol_AvAg_10_anni[12,])),sol = c(rep("sol1_AvAg",200),rep("sol2_AvAg",200),rep("sol3_AvAg",200),rep("sol4_AvAg",200),rep("sol5_AvAg",200),rep("sol6_AvAg",200),rep("sol7_AvAg",200),rep("sol8_AvAg",200),rep("sol9_AvAg",200),rep("sol10_AvAg",200),rep("sol11_AvAg",200),rep("sol12_AvAg",200)))
str(sol_AvAg_10_anni_df)
# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
library("ggpubr")
library(ggplot2)
dev.new()
p = ggboxplot(sol_AvAg_10_anni_df, x = "sol", y = "valore", 
          color = "sol",
          ylab = "Value", xlab = "Solution",  size=1,
  font.label = list(size = 14), # Cambia la dimensione del testo
ggtheme = theme_pubr(base_size = 14) # Cambia la dimensione generale
)+
  theme(axis.text = element_text(size = 12), # Cambia la dimensione delle etichette degli assi
        axis.title = element_text(size = 14), legend.text = element_text(size = 18), # Cambia la dimensione del testo della legenda
        legend.title = element_text(size = 14) # Cambia la dimensione del titolo della legenda
  ) 
ggsave("AvAg_10years.pdf", plot = p, width = 12, height = 9)

# Mean plots
# ++++++++++++++++++++
# Plot weight by group
# Add error bars: mean_se
# (other values include: mean_sd, mean_ci, median_iqr, ....)
ggline(sol_AvAg_10_anni_df, x = "sol", y = "valore", 
       add = c("mean_se", "jitter"), 
       ylab = "Value", xlab = "Solution")


kruskal.test(valore ~ sol, data = sol_AvAg_10_anni_df)


a = pairwise.wilcox.test(sol_AvAg_10_anni_df$valore, sol_AvAg_10_anni_df$sol,
                     p.adjust.method = "BH")
pvalues_matrix <- as.data.frame(a$p.value)

write.csv(pvalues_matrix, "AvAg_10_anni.csv", row.names = TRUE)

#variance
AvAg_10anni = pairwise_variance(sol_AvAg_10_anni_df, group_col = "sol", value_col = "valore")
AvAg_10anni
which(AvAg_10anni$p_adjusted<0.05)

#20 years solution

sol_AvAg_20_anni = read.csv('soluzioni_AvAg_20anni.csv',dec=",",sep=';',header=FALSE,row.names=1)
sol_AvAg_20_anni_df = data.frame(valore = c(t(sol_AvAg_20_anni[1,]),t(sol_AvAg_20_anni[2,]),t(sol_AvAg_20_anni[3,]),t(sol_AvAg_20_anni[4,]),t(sol_AvAg_20_anni[5,]),t(sol_AvAg_20_anni[6,]),t(sol_AvAg_20_anni[7,]),t(sol_AvAg_20_anni[8,]),t(sol_AvAg_20_anni[9,]),t(sol_AvAg_20_anni[10,]),t(sol_AvAg_20_anni[11,]),t(sol_AvAg_20_anni[12,])),sol = c(rep("sol1_AvAg",200),rep("sol2_AvAg",200),rep("sol3_AvAg",200),rep("sol4_AvAg",200),rep("sol5_AvAg",200),rep("sol6_AvAg",200),rep("sol7_AvAg",200),rep("sol8_AvAg",200),rep("sol9_AvAg",200),rep("sol10_AvAg",200),rep("sol11_AvAg",200),rep("sol12_AvAg",200)))
str(sol_AvAg_20_anni_df)
# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
library("ggpubr")
library(ggplot2)
dev.new()
p = ggboxplot(sol_AvAg_20_anni_df, x = "sol", y = "valore", 
              color = "sol",
              ylab = "Value", xlab = "Solution",  size=1,
              font.label = list(size = 14), # Cambia la dimensione del testo
              ggtheme = theme_pubr(base_size = 14) # Cambia la dimensione generale
)+
  theme(axis.text = element_text(size = 12), # Cambia la dimensione delle etichette degli assi
        axis.title = element_text(size = 14), legend.text = element_text(size = 18), # Cambia la dimensione del testo della legenda
        legend.title = element_text(size = 14) # Cambia la dimensione del titolo della legenda
  ) 
ggsave("AvAg_20years.pdf", plot = p, width = 12, height = 9)
# Mean plots
# ++++++++++++++++++++
# Plot weight by group
# Add error bars: mean_se
# (other values include: mean_sd, mean_ci, median_iqr, ....)
ggline(sol_AvAg_20_anni_df, x = "sol", y = "valore", 
       add = c("mean_se", "jitter"), 
       ylab = "Value", xlab = "Solution")


kruskal.test(valore ~ sol, data = sol_AvAg_20_anni_df)

a = pairwise.wilcox.test(sol_AvAg_20_anni_df$valore, sol_AvAg_20_anni_df$sol,
                         p.adjust.method = "BH")
pvalues_matrix <- as.data.frame(a$p.value)

write.csv(pvalues_matrix, "AvAg_20_anni.csv", row.names = TRUE)

#variance
AvAg_20anni = pairwise_variance(sol_AvAg_20_anni_df, group_col = "sol", value_col = "valore")
AvAg_20anni
which(AvAg_20anni$p_adjusted<0.05)

#30 years solutions


sol_AvAg_30_anni = read.csv('soluzioni_AvAg_30anni.csv',dec=",",sep=';',header=FALSE,row.names=1)
sol_AvAg_30_anni_df = data.frame(valore = c(t(sol_AvAg_30_anni[1,]),t(sol_AvAg_30_anni[2,]),t(sol_AvAg_30_anni[3,]),t(sol_AvAg_30_anni[4,]),t(sol_AvAg_30_anni[5,]),t(sol_AvAg_30_anni[6,]),t(sol_AvAg_30_anni[7,]),t(sol_AvAg_30_anni[8,]),t(sol_AvAg_30_anni[9,]),t(sol_AvAg_30_anni[10,]),t(sol_AvAg_30_anni[11,]),t(sol_AvAg_30_anni[12,])),sol = c(rep("sol1_AvAg",200),rep("sol2_AvAg",200),rep("sol3_AvAg",200),rep("sol4_AvAg",200),rep("sol5_AvAg",200),rep("sol6_AvAg",200),rep("sol7_AvAg",200),rep("sol8_AvAg",200),rep("sol9_AvAg",200),rep("sol10_AvAg",200),rep("sol11_AvAg",200),rep("sol12_AvAg",200)))
str(sol_AvAg_30_anni_df)
# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
library("ggpubr")
library(ggplot2)
dev.new()
p = ggboxplot(sol_AvAg_30_anni_df, x = "sol", y = "valore", 
              color = "sol",
              ylab = "Value", xlab = "Solution",  size=1,
              font.label = list(size = 14), # Cambia la dimensione del testo
              ggtheme = theme_pubr(base_size = 14) # Cambia la dimensione generale
)+
  theme(axis.text = element_text(size = 12), # Cambia la dimensione delle etichette degli assi
        axis.title = element_text(size = 14), legend.text = element_text(size = 18), # Cambia la dimensione del testo della legenda
        legend.title = element_text(size = 14) # Cambia la dimensione del titolo della legenda
  ) 
ggsave("AvAg_30years.pdf", plot = p, width = 12, height = 9)
# Mean plots
# ++++++++++++++++++++
# Plot weight by group
# Add error bars: mean_se
# (other values include: mean_sd, mean_ci, median_iqr, ....)
ggline(sol_AvAg_30_anni_df, x = "sol", y = "valore", 
       add = c("mean_se", "jitter"), 
       ylab = "Value", xlab = "Solution")


kruskal.test(valore ~ sol, data = sol_AvAg_30_anni_df)

a = pairwise.wilcox.test(sol_AvAg_30_anni_df$valore, sol_AvAg_30_anni_df$sol,
                         p.adjust.method = "BH")
pvalues_matrix <- as.data.frame(a$p.value)

write.csv(pvalues_matrix, "AvAg_30_anni.csv", row.names = TRUE)
#variance
AvAg_30anni = pairwise_variance(sol_AvAg_30_anni_df, group_col = "sol", value_col = "valore")
AvAg_30anni
which(AvAg_30anni$p_adjusted<0.05)

