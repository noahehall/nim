echo "############################ REEEAAALLLY should todo type list"
# GC_Strategy (enum) the application should use
  # gcThroughput,             ## optimize for throughput
  # gcResponsiveness,         ## optimize for responsiveness (default)
  # gcOptimizeTime,           ## optimize for speed
  # gcOptimizeSpace            ## optimize for memory footprint
# owned[T] mark a ref/ptr/closure as owned
# pointer use addr operator to get a pointer to a variable

echo "############################ skipped type list"
# @see https://nim-lang.org/docs/system.html#7 are somewhere on this page
# AllocStats
# AtomType
# Endianness
# FileSeekPos
# ForeignCell
# lent[T]
# sink[T]
# StackTraceEntry a single entry in a stack trace
# TFrame something to do with callstacks
# TypeOfMode something to do with proc/iter invocations
