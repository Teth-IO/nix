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
        "CC=${pkgs.llvmPackages.clang}/bin/clang"
        "LD=${pkgs.lld}/bin/ld.lld"
        "AR=${pkgs.llvm}/bin/llvm-ar"
        "NM=${pkgs.llvm}/bin/llvm-nm"
        "KCFLAGS+=-march=native"
        "KCFLAGS+=-flto=thin"
        "KCXXFLAGS+=-march=native"
        "KCXXFLAGS+=-flto=thin"
        "NIX_ENFORCE_NO_NATIVE=0"
      ];
      ignoreConfigErrors = true;
      structuredExtraConfig = with lib.kernel; {
        LTO_CLANG_THIN = lib.mkForce yes;
      };
    };
  });
}