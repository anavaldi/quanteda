
# correlation
test_that("test textstat_simil method = \"correlation\" against proxy simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    corQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, method = "correlation", margin = "documents"))[,"1981-Reagan"], 6), decreasing = TRUE)
    corProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), by_rows = TRUE, diag = TRUE))[, "1981-Reagan"], 6), decreasing = TRUE)
    corCor <- sort(cor(as.matrix(t(presDfm)))[, "1981-Reagan"], decreasing = TRUE)
    expect_equal(corQuanteda[-9], corProxy[-9], corCor[-1])
})

test_that("test textstat_simil method = \"correlation\" against base cor(): features (allow selection)", {
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    corQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "union", method = "correlation", margin = "features"))[,"union"], 6), decreasing = TRUE)
    corStats <- sort(round(cor(as.matrix(presDfm))[, "union"], 6), decreasing = TRUE)
    expect_equal(corQuanteda[1:10], corStats[2:11])
})

# cosine
test_that("test textstat_simil method = \"cosine\" against proxy simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    cosQuanteda <- round(as.matrix(textstat_simil(presDfm, method = "cosine", margin = "features"))[,"soviet"], 2)
    cosQuanteda <- cosQuanteda[order(names(cosQuanteda))]
    cosQuanteda <- cosQuanteda[-which(names(cosQuanteda) == "soviet")]
    
    cosProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "cosine", by_rows = FALSE)), 2)
    cosProxy <- cosProxy[order(names(cosProxy))]
    cosProxy <- cosProxy[-which(names(cosProxy) == "soviet")]
    
    expect_equal(cosQuanteda, cosProxy)
})


test_that("test textstat_simil method = \"cosine\" against proxy simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    cosQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, method = "cosine", margin = "documents"))[,"1981-Reagan"], 6), decreasing = TRUE)
    cosProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "cosine", by_rows = TRUE, diag = TRUE))[, "1981-Reagan"], 6), decreasing = TRUE)
    expect_equal(cosQuanteda[-9], cosProxy[-9])
})

# euclidean 
test_that("test textstat_dist method = \"euclidean\" against proxy dist() and stats dist(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    eucQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet", method = "euclidean", margin = "features"))[,"soviet"], 2)
    eucQuanteda <- eucQuanteda[order(names(eucQuanteda))]
    eucQuanteda <- eucQuanteda[-which(names(eucQuanteda) == "soviet")]
    
    eucProxy <- round(drop(proxy::dist(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "euclidean", by_rows = FALSE)), 2)
    eucProxy <- eucProxy[order(names(eucProxy))]
    eucProxy <- eucProxy[-which(names(eucProxy) == "soviet")]
    
    expect_equal(eucQuanteda, eucProxy)
})

test_that("test textstat_dist method = \"Euclidean\" against proxy dist() and stats dist(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    eucQuanteda <- sort(round(as.matrix(textstat_dist(presDfm, method = "euclidean", margin = "documents"))[,"1981-Reagan"], 6), decreasing = FALSE)
    eucProxy <- sort(round(as.matrix(proxy::dist(as.matrix(presDfm), "euclidean", diag = FALSE, upper = FALSE, p = 2))[, "1981-Reagan"], 6), decreasing = FALSE)
    eucStats <- sort(round(as.matrix(stats::dist(as.matrix(presDfm), method = "euclidean", diag = FALSE, upper = FALSE, p = 2))[,"1981-Reagan"], 6),  decreasing = FALSE)
    expect_equal(eucQuanteda, eucProxy, eucStats)
})

# jaccard - binary
test_that("test textstat_simil method = \"jaccard\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    jacQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "jaccard", margin = "documents", diag= FALSE, upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    jacQuanteda <- jacQuanteda[-which(names(jacQuanteda) == "1981-Reagan")]
    jacProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "jaccard", diag = FALSE, upper = FALSE, p = 2))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(jacProxy)) jacProxy <- jacProxy[-which(names(jacProxy) == "1981-Reagan")]
    expect_equal(jacQuanteda, jacProxy)
})

test_that("test textstat_simil method = \"jaccard\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    jacQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "jaccard", margin = "features"))[,"soviet"], 2)
    jacQuanteda <- jacQuanteda[order(names(jacQuanteda))]
    jacQuanteda <- jacQuanteda[-which(names(jacQuanteda) == "soviet")]
    
    jacProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "jaccard", by_rows = FALSE)), 2)
    jacProxy <- jacProxy[order(names(jacProxy))]
    if("soviet" %in% names(jacProxy)) jacProxy <- jacProxy[-which(names(jacProxy) == "soviet")]
    
    expect_equal(jacQuanteda, jacProxy)
})

# ejaccard - real-valued data
test_that("test textstat_simil method = \"ejaccard\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    ejacQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "eJaccard", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    ejacQuanteda <- ejacQuanteda[-which(names(ejacQuanteda) == "1981-Reagan")]
    ejacProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "ejaccard", diag = FALSE, upper = FALSE, p = 2))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(ejacProxy)) ejacProxy <- ejacProxy[-which(names(ejacProxy) == "1981-Reagan")]
    expect_equal(ejacQuanteda, ejacProxy)
})

test_that("test textstat_simil method = \"ejaccard\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    ejacQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "eJaccard", margin = "features"))[,"soviet"], 2)
    ejacQuanteda <- ejacQuanteda[order(names(ejacQuanteda))]
    ejacQuanteda <- ejacQuanteda[-which(names(ejacQuanteda) == "soviet")]
    
    ejacProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "ejaccard", by_rows = FALSE)), 2)
    ejacProxy <- ejacProxy[order(names(ejacProxy))]
    if("soviet" %in% names(ejacProxy)) ejacProxy <- ejacProxy[-which(names(ejacProxy) == "soviet")]
    
    expect_equal(ejacQuanteda, ejacProxy)
})

# dice -binary
test_that("test textstat_simil method = \"dice\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    diceQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "dice", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    diceQuanteda <- diceQuanteda[-which(names(diceQuanteda) == "1981-Reagan")]
    diceProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "dice", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(diceProxy)) diceProxy <- diceProxy[-which(names(diceProxy) == "1981-Reagan")]
    expect_equal(diceQuanteda, diceProxy)
})

test_that("test textstat_simil method = \"dice\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    diceQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "dice", margin = "features"))[,"soviet"], 2)
    diceQuanteda <- diceQuanteda[order(names(diceQuanteda))]
    diceQuanteda <- diceQuanteda[-which(names(diceQuanteda) == "soviet")]
    
    diceProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "dice", by_rows = FALSE)), 2)
    diceProxy <- diceProxy[order(names(diceProxy))]
    diceProxy <- diceProxy[-which(names(diceProxy) == "soviet")]
    
    expect_equal(diceQuanteda, diceProxy)
})

# edice -real valued data
test_that("test textstat_simil method = \"edice\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    ediceQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "eDice", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    ediceQuanteda <- ediceQuanteda[-which(names(ediceQuanteda) == "1981-Reagan")]
    ediceProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "edice", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(ediceProxy)) ediceProxy <- ediceProxy[-which(names(ediceProxy) == "1981-Reagan")]
    expect_equal(ediceQuanteda, ediceProxy)
})

test_that("test textstat_simil method = \"edice\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    ediceQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "eDice", margin = "features"))[,"soviet"], 2)
    ediceQuanteda <- ediceQuanteda[order(names(ediceQuanteda))]
    ediceQuanteda <- ediceQuanteda[-which(names(ediceQuanteda) == "soviet")]
    
    ediceProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "edice", by_rows = FALSE)), 2)
    ediceProxy <- ediceProxy[order(names(ediceProxy))]
    ediceProxy <- ediceProxy[-which(names(ediceProxy) == "soviet")]
    
    expect_equal(ediceQuanteda, ediceProxy)
})

# simple matching coefficient
test_that("test textstat_simil method = \"simple matching\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    smcQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "simple matching", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    smcQuanteda <- smcQuanteda[-which(names(smcQuanteda) == "1981-Reagan")]
    smcProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "simple matching", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(smcProxy)) smcProxy <- smcProxy[-which(names(smcProxy) == "1981-Reagan")]
    expect_equal(smcQuanteda, smcProxy)
})

test_that("test textstat_simil method = \"simple matching\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    smcQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "simple matching", margin = "features"))[,"soviet"], 2)
    smcQuanteda <- smcQuanteda[order(names(smcQuanteda))]
    smcQuanteda <- smcQuanteda[-which(names(smcQuanteda) == "soviet")]
    
    smcProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "simple matching", by_rows = FALSE)), 2)
    smcProxy <- smcProxy[order(names(smcProxy))]
    smcProxy <- smcProxy[-which(names(smcProxy) == "soviet")]
    
    expect_equal(smcQuanteda, smcProxy)
})

# Hamann similarity (Hamman similarity in proxy::dist)
test_that("test textstat_simil method = \"hamann\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    hamnQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "hamann", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    hamnQuanteda <- hamnQuanteda[-which(names(hamnQuanteda) == "1981-Reagan")]
    hamnProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "hamman", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(hamnProxy)) hamnProxy <- hamnProxy[-which(names(hamnProxy) == "1981-Reagan")]
    expect_equal(hamnQuanteda, hamnProxy)
})

test_that("test textstat_simil method = \"hamann\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    hamnQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "hamann", margin = "features"))[,"soviet"], 2)
    hamnQuanteda <- hamnQuanteda[order(names(hamnQuanteda))]
    hamnQuanteda <- hamnQuanteda[-which(names(hamnQuanteda) == "soviet")]
    
    hamnProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "hamman", by_rows = FALSE)), 2)
    hamnProxy <- hamnProxy[order(names(hamnProxy))]
    hamnProxy <- hamnProxy[-which(names(hamnProxy) == "soviet")]
    
    expect_equal(hamnQuanteda, hamnProxy)
})

# Faith similarity 
test_that("test textstat_simil method = \"faith\" against proxy::simil(): documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    faithQuanteda <- sort(round(as.matrix(textstat_simil(presDfm, "1981-Reagan", method = "faith", margin = "documents", upper = TRUE))[,"1981-Reagan"], 6), decreasing = FALSE)
    faithQuanteda <- faithQuanteda[-which(names(faithQuanteda) == "1981-Reagan")]
    faithProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "faith", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
    if("1981-Reagan" %in% names(faithProxy)) faithProxy <- faithProxy[-which(names(faithProxy) == "1981-Reagan")]
    expect_equal(faithQuanteda, faithProxy)
})

test_that("test textstat_simil method = \"faith\" against proxy::simil(): features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    faithQuanteda <- round(as.matrix(textstat_simil(presDfm, "soviet", method = "faith", margin = "features"))[,"soviet"], 2)
    faithQuanteda <- faithQuanteda[order(names(faithQuanteda))]
    faithQuanteda <- faithQuanteda[-which(names(faithQuanteda) == "soviet")]
    
    faithProxy <- round(drop(proxy::simil(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "faith", by_rows = FALSE)), 2)
    faithProxy <- faithProxy[order(names(faithProxy))]
    faithProxy <- faithProxy[-which(names(faithProxy) == "soviet")]
    
    expect_equal(faithQuanteda, faithProxy)
})

# Chi-squared distance 
# Instead of comparing to Proxy package, ExPosition is compared to. Because Proxy::simil uses different formula
# eucProxy <- sort(round(as.matrix(proxy::simil(as.matrix(presDfm), "Chi-squared", diag = FALSE, upper = FALSE))[, "1981-Reagan"], 6), decreasing = FALSE)
test_that("test textstat_dist method = \"Chi-squred\" against ExPosition::chi2Dist(): features", {
    skip_if_not_installed("ExPosition")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    chiQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet", method = "Chisquared", margin = "features"))[,"soviet"], 2)
    chiQuanteda <- chiQuanteda[order(names(chiQuanteda))]
    chiQuanteda <- chiQuanteda[-which(names(chiQuanteda) == "soviet")]
    
    chiExp <- ExPosition::chi2Dist(t(as.matrix(presDfm)))
    chiExp <- sort(round(as.matrix(chiExp$D)[, "soviet"], 2), decreasing = FALSE)
    chiExp <- chiExp[order(names(chiExp))]
    chiExp <- chiExp[-which(names(chiExp) == "soviet")]
    
    expect_equal(chiQuanteda, chiExp)
})

test_that("test textstat_dist method = \"Chi-squred\" against ExPosition::chi2Dist(): documents", {
    skip_if_not_installed("ExPosition")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    chiQuanteda <- sort(round(as.matrix(textstat_dist(presDfm, method = "Chisquared", margin = "documents"))[,"1981-Reagan"], 6), decreasing = FALSE)
    chiExp <- ExPosition::chi2Dist(as.matrix(presDfm))
    chiExp <- sort(round(as.matrix(chiExp$D)[, "1981-Reagan"], 6), decreasing = FALSE)
    expect_equal(chiQuanteda, chiExp)
})

# Kullback-Leibler divergence
# proxy::dist() will generate NA for matrix with zeros, hence a matrix only with non-zero entries is used here.
test_that("test textstat_dist method = \"Kullback-Leibler\" against proxy dist(): documents", {
    skip_if_not_installed("proxy")
    m <- matrix(rexp(550, rate=.1), nrow = 5)
    kullQuanteda <- round(as.matrix(textstat_dist(as.dfm(m), method = "kullback", margin = "documents")), 2)
    kullProxy <- round(as.matrix(proxy::dist(m, "kullback", diag = FALSE, upper = FALSE)), 2)
    expect_equal(kullQuanteda, kullProxy)
})

# Manhattan distance
test_that("test textstat_dist method = \"manhattan\" against proxy dist() : documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    manQuanteda <- round(as.matrix(textstat_dist(presDfm, method = "manhattan", margin = "documents")), 2)
    manProxy <- round(as.matrix(proxy::dist(as.matrix(presDfm), "manhattan", diag = FALSE, upper = FALSE)), 2)
    expect_equal(manQuanteda, manProxy)
})

test_that("test textstat_dist method = \"manhattan\" against proxy dist() : features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    manQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet",  method = "manhattan", margin = "features"))[,"soviet"], 2)
    manQuanteda <- manQuanteda[order(names(manQuanteda))]
    manQuanteda <- manQuanteda[-which(names(manQuanteda) == "soviet")]
    
    manProxy <- round(drop(proxy::dist(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "manhattan", by_rows = FALSE)), 2)
    manProxy <- manProxy[order(names(manProxy))]
    manProxy <- manProxy[-which(names(manProxy) == "soviet")]
    expect_equal(manQuanteda, manProxy)
})

# Maximum/Supremum distance
test_that("test textstat_dist method = \"Maximum\" against proxy dist() : documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    maxQuanteda <- round(as.matrix(textstat_dist(presDfm, method = "maximum", margin = "documents")), 2)
    maxProxy <- round(as.matrix(proxy::dist(as.matrix(presDfm), "maximum", diag = FALSE, upper = FALSE)), 2)
    expect_equal(maxQuanteda, maxProxy)
})

test_that("test textstat_dist method = \"Maximum\" against proxy dist() : features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    maxQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet",  method = "maximum", margin = "features"))[,"soviet"], 2)
    maxQuanteda <- maxQuanteda[order(names(maxQuanteda))]
    maxQuanteda <- maxQuanteda[-which(names(maxQuanteda) == "soviet")]
    
    maxProxy <- round(drop(proxy::dist(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "maximum", by_rows = FALSE)), 2)
    maxProxy <- maxProxy[order(names(maxProxy))]
    maxProxy <- maxProxy[-which(names(maxProxy) == "soviet")]
    expect_equal(maxQuanteda, maxProxy)
})

# Canberra distance
test_that("test textstat_dist method = \"Canberra\" against proxy dist() : documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    canQuanteda <- round(as.matrix(textstat_dist(presDfm, method = "canberra", margin = "documents")), 2)
    canProxy <- round(as.matrix(proxy::dist(as.matrix(presDfm), "canberra", diag = FALSE, upper = FALSE)), 2)
    expect_equal(canQuanteda, canProxy)
})

test_that("test textstat_dist method = \"Canberra\" against proxy dist() : features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980 & Year < 2017), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    canQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet",  method = "canberra", margin = "features"))[,"soviet"], 2)
    canQuanteda <- canQuanteda[order(names(canQuanteda))]
    canQuanteda <- canQuanteda[-which(names(canQuanteda) == "soviet")]
    
    canProxy <- round(drop(proxy::dist(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "canberra", by_rows = FALSE)), 2)
    canProxy <- canProxy[order(names(canProxy))]
    canProxy <- canProxy[-which(names(canProxy) == "soviet")]
    expect_equal(canQuanteda, canProxy)
})

# Minkowski distance
test_that("test textstat_dist method = \"Minkowski\" against proxy dist() : documents", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    minkQuanteda <- round(as.matrix(textstat_dist(presDfm, method = "minkowski", margin = "documents", p = 3)), 2)
    minkProxy <- round(as.matrix(proxy::dist(as.matrix(presDfm), "minkowski", diag = FALSE, upper = FALSE, p=3)), 2)
    expect_equal(minkQuanteda, minkProxy)
})

test_that("test textstat_dist method = \"Canberra\" against proxy dist() : features", {
    skip_if_not_installed("proxy")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    minkQuanteda <- round(as.matrix(textstat_dist(presDfm, "soviet",  method = "minkowski", margin = "features", p = 4))[,"soviet"], 2)
    minkQuanteda <- minkQuanteda[order(names(minkQuanteda))]
    minkQuanteda <- minkQuanteda[-which(names(minkQuanteda) == "soviet")]
    
    minkProxy <- round(drop(proxy::dist(as.matrix(presDfm), as.matrix(presDfm[, "soviet"]), "minkowski", by_rows = FALSE, p = 4)), 2)
    minkProxy <- minkProxy[order(names(minkProxy))]
    minkProxy <- minkProxy[-which(names(minkProxy) == "soviet")]
    expect_equal(minkQuanteda, minkProxy)
})

# Hamming distance
test_that("test textstat_dist method = \"hamming\" against e1071::hamming.distance: documents", {
    skip_if_not_installed("e1071")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    hammingQuanteda <- sort(as.matrix(textstat_dist(presDfm, "1981-Reagan", method = "hamming", margin = "documents", upper = TRUE))[,"1981-Reagan"], decreasing = FALSE)
    hammingQuanteda <- hammingQuanteda[-which(names(hammingQuanteda) == "1981-Reagan")]
    hammingE1071 <- sort(e1071::hamming.distance(as.matrix(tf(presDfm, "boolean")))[, "1981-Reagan"], decreasing = FALSE)
    if("1981-Reagan" %in% names(hammingE1071)) hammingE1071 <- hammingE1071[-which(names(hammingE1071) == "1981-Reagan")]
    expect_equal(hammingQuanteda, hammingE1071)
})

test_that("test textstat_dist method = \"hamming\" against e1071::hamming.distance: features", {
    skip_if_not_installed("e1071")
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    
    hammingQuanteda <- as.matrix(textstat_dist(presDfm, "soviet", method = "hamming", margin = "features"))[,"soviet"]
    hammingQuanteda <- hammingQuanteda[order(names(hammingQuanteda))]
    hammingQuanteda <- hammingQuanteda[-which(names(hammingQuanteda) == "soviet")]
    
    presM <- t(as.matrix(tf(presDfm, "boolean")))
    hammingE1071 <- e1071::hamming.distance(presM)[, "soviet"]
    hammingE1071 <- hammingE1071[order(names(hammingE1071))]
    if("soviet" %in% names(hammingE1071)) hammingE1071 <- hammingE1071[-which(names(hammingE1071) == "soviet")]
    expect_equal(hammingQuanteda, hammingE1071)
})

test_that("as.list.dist works as expected",{
    presDfm <- dfm(corpus_subset(inaugCorpus, Year > 1980), remove = stopwords("english"),
                   stem = TRUE, verbose = FALSE)
    ddist <- textstat_dist(presDfm, method = "hamming")
    ddist_list <- as.list(ddist)
    expect_equal(names(ddist_list$`1981-Reagan`)[1:3], c("2009-Obama", "2013-Obama", "1997-Clinton"))
    expect_equivalent(ddist_list$`1981-Reagan`[1:3], c(851, 804, 785))
})
