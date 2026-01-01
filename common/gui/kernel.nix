{
  lib,
  pkgs,
  ...
} @ args:
{
  boot.kernelPackages = pkgs.linuxPackagesFor
  (pkgs.linuxKernel.kernels.linux_6_18.override {
    argsOverride = rec {
      stdenv = pkgs.kernllvmPackages.stdenv;
      extraMakeFlags = [
        "LLVM=1"
        "CC=${pkgs.llvmPackages.clangUseLLVM}/bin/clang"
        "HOSTCC=${pkgs.llvmPackages.clangUseLLVM}/bin/clang"
        "HOSTCXX=${pkgs.llvmPackages.clangUseLLVM}/bin/clang++"
        "LD=${pkgs.lld}/bin/ld.lld"
        "HOSTLD=${pkgs.lld}/bin/ld.lld"
        "AR=${pkgs.llvm}/bin/llvm-ar"
        "HOSTAR=${pkgs.llvm}/bin/llvm-ar"
        "NM=${pkgs.llvm}/bin/llvm-nm"
        "STRIP=${pkgs.llvm}/bin/llvm-strip"
        "OBJCOPY=${pkgs.llvm}/bin/llvm-objcopy"
        "OBJDUMP=${pkgs.llvm}/bin/llvm-objdump"
        "READELF=${pkgs.llvm}/bin/llvm-readelf"
        "KCFLAGS+=-march=native"
        "KCFLAGS+=-flto=thin"
        "KCFLAGS+=-O3"
        "NIX_ENFORCE_NO_NATIVE=0"
      ];
      ignoreConfigErrors = true;
      structuredExtraConfig = with lib.kernel; {
        LTO_CLANG_THIN = lib.mkForce yes;
      };
    };
  });
}
