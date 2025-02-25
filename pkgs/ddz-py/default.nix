{
  python3Packages,
  fetchFromGitHub,
  lib,
  writeText,
  bash,
}:

python3Packages.buildPythonApplication rec {
  pname = "ddz_py";
  version = "0-unstable-2024-01-20";

  format = "other";

  src = fetchFromGitHub {
    owner = "EarthMessenger";
    repo = "ddz_py";
    rev = "f3121679021057406467f79a10d888c4547809b4";
    hash = "sha256-2a7ildZ9rT3BbdjeHtCh0jdFulxz8FlmMnO1qytLa1k=";
  };

  client_deluxe = writeText "a.sh" ''
    #! ${lib.getExe bash}
    python -m ddz_py.client_deluxe "$@"
  '';

  client_vanilla = writeText "a.sh" ''
    #! ${lib.getExe bash}
    python -m ddz_py.client_vanilla "$@"
  '';

  dependencies = with python3Packages; [
    colorama
    prompt-toolkit
    wcwidth
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3Packages.python.sitePackages}/ddz_py
    cp -r ${src}/ddz_py/* $out/${python3Packages.python.sitePackages}/ddz_py

    install -Dm755 ${client_deluxe} $out/bin/client_deluxe
    install -Dm755 ${client_vanilla} $out/bin/client_vanilla
    wrapProgram "$out/bin/client_vanilla" \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}" \
      --prefix PATH : "${python3Packages.python}/bin"

    wrapProgram "$out/bin/client_deluxe" \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3Packages.python.sitePackages}" \
      --prefix PATH : "${python3Packages.python}/bin"

    runHook postInstall
  '';

  pythonImportsCheck = [
    "ddz_py"
    "ddz_py.client_deluxe"
    "ddz_py.client_vanilla"
  ];

  meta = {
    license = lib.licenses.free;
    homepage = "https://github.com/EarthMessenger/ddz_py";
    mainProgram = "client_deluxe";
    description = "CLI game";
  };
}
