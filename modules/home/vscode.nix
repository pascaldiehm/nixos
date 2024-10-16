{ lib, pkgs, ... }: {
  # Dependencies
  fonts.fontconfig.enable = true;

  home.packages = [
    # Font
    pkgs.jetbrains-mono

    # Updating marketplace extensions
    pkgs.jq
    pkgs.unzip
  ];

  # Setup VSCode
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      bbenoist.nix
      bmewburn.vscode-intelephense-client
      esbenp.prettier-vscode
      github.copilot
      github.copilot-chat
      james-yu.latex-workshop
      ms-python.black-formatter
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-vsliveshare.vsliveshare
      pkief.material-icon-theme
      streetsidesoftware.code-spell-checker
      usernamehw.errorlens
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (lib.importJSON ../../resources/vscode-extensions.json);

    userSettings = {
      # Editor
      "editor.fontFamily" = "JetBrains Mono";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlayHints.enabled" = "off";
      "editor.lineNumbers" = "relative";
      "editor.linkedEditing" = true;
      "explorer.compactFolders" = false;
      "extensions.experimental.affinity" = { "vscodevim.vim" = 1; };
      "extensions.ignoreRecommendations" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.showExitAlert" = false;
      "update.showReleaseNotes" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";

      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "always";
        "source.removeUnusedImports" = "always";
        "source.sortImports" = "always";
      };

      # General
      "cSpell.language" = "en,de";
      "material-icon-theme.activeIconPack" = "react";
      "vim.handleKeys" = { "<C-i>" = false; "<C-k>" = false; "<C-p>" = false; "<C-s>" = true; "<C-z>" = true; };
      "vim.useSystemClipboard" = true;

      # Git
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.inputValidation" = true;
      "git.openRepositoryInParentFolders" = "always";

      # Prettier
      "prettier.arrowParens" = "avoid";
      "prettier.bracketSameLine" = true;
      "prettier.printWidth" = 150;

      # PHP
      "intelephense.format.braces" = "k&r";

      # Python
      "black-formatter.args" = [ "--line-length" "150" ];
      "python.analysis.autoFormatStrings" = true;
      "python.analysis.autoImportCompletions" = true;
      "python.analysis.typeCheckingMode" = "standard";

      # Languages
      "[json]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; "editor.tabSize" = 2; };
      "[jsonc]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; "editor.tabSize" = 2; };
      "[nix]" = { "editor.tabSize" = 2; };
    };
  };
}
