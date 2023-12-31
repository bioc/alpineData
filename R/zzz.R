.onLoad <- function(libname, pkgname) {
  objs <- read.csv(system.file("extdata", "metadata.csv",
                                package="alpineData"),
                    stringsAsFactors=FALSE)$Title
  if (!length(objs))
    stop("no objects found")
 
  ## Functions to load objects by name:
  ns <- asNamespace(pkgname)
  sapply(objs,
         function(xx) {
           func = function(metadata = FALSE) {
             if (!isNamespaceLoaded("ExperimentHub"))
               attachNamespace("ExperimentHub")
             eh <- query(ExperimentHub(), "alpineData")
             ehid <- names(query(eh, xx))
             if (!length(ehid))
               stop(paste0("resource ", xx,
                           "not found in ExperimentHub"))
             if (metadata)
               eh[ehid]
             else eh[[ehid]]
           }
           assign(xx, func, envir=ns)
           namespaceExport(ns, xx)
         })
}
.onAttach <- function(libname, pkgname) {
    msg <- sprintf(
        "Package '%s' is deprecated and will be removed from Bioconductor
         version %s", pkgname, "3.18")
    .Deprecated(msg=paste(strwrap(msg, exdent=2), collapse="\n"))
}

