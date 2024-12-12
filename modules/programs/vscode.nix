{ lib, pkgs, ... }: {
  home-manager.users.pascal.programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    keybindings = [{ key = "shift+enter"; command = "-python.execSelectionInTerminal"; }];
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      foxundermoon.shell-format
      github.vscode-github-actions
      james-yu.latex-workshop
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      ms-azuretools.vscode-docker
      ms-python.isort
      ms-python.python
      ms-vscode.cmake-tools
      pkief.material-icon-theme
      streetsidesoftware.code-spell-checker
      twxs.cmake
      redhat.java
      usernamehw.errorlens
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (lib.importJSON ../../resources/extensions/vscode.json);

    userSettings = {
      # Editor
      "editor.fontFamily" = "Cascadia Code";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlayHints.enabled" = "off";
      "editor.lineNumbers" = "relative";
      "editor.linkedEditing" = true;
      "editor.tabSize" = 2;
      "explorer.compactFolders" = false;
      "extensions.experimental.affinity" = { "vscodevim.vim" = 1; };
      "extensions.ignoreRecommendations" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.showExitAlert" = false;
      "update.showReleaseNotes" = false;
      "workbench.editorAssociations" = { "*.pdf" = "latex-workshop-pdf-hook"; };
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";

      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "always";
        "source.removeUnusedImports" = "always";
        "source.sortImports" = "always";
      };

      # General
      "cSpell.enabledFileTypes" = { "*" = true; };
      "cSpell.language" = "en,de";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.inputValidation" = true;
      "git.openRepositoryInParentFolders" = "always";
      "material-icon-theme.activeIconPack" = "react";
      "vim.handleKeys" = { "<C-i>" = false; "<C-k>" = false; "<C-p>" = false; "<C-s>" = true; "<C-z>" = true; };
      "vim.useSystemClipboard" = true;

      # C++
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "cmake.configureOnOpen" = true;

      # Java
      "java.compile.nullAnalysis.mode" = "automatic";
      "java.configuration.updateBuildConfiguration" = "automatic";
      "java.format.settings.url" = "${../../resources/java-format.xml}";
      "redhat.telemetry.enabled" = false;

      # LaTeX
      "latex-workshop.latex.autoClean.run" = "onSucceeded";

      # PHP
      "intelephense.format.braces" = "k&r";

      # Prettier
      "prettier.arrowParens" = "avoid";
      "prettier.bracketSameLine" = true;
      "prettier.printWidth" = 120;

      # Python
      "autopep8.args" = [ "--indent-size=2" "--max-line-length=120" ];

      # Formatters
      "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[dockerfile]"."editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
      "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";
    };
  };
}
