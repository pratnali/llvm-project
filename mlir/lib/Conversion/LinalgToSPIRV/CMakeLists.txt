add_llvm_library(MLIRLinalgToSPIRVTransforms
  LinalgToSPIRV.cpp
  LinalgToSPIRVPass.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/SPIRV
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/IR
  )

target_link_libraries(MLIRLinalgToSPIRVTransforms
  MLIRIR
  MLIRLinalgOps
  MLIRPass
  MLIRSPIRV
  MLIRSupport
  )
