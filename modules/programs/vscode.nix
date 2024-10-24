{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    # Setup dependencies
    fonts.fontconfig.enable = true;
    home.packages = [ pkgs.jetbrains-mono pkgs.jq pkgs.nixpkgs-fmt pkgs.unzip ];

    # Setup VSCode
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;

      extensions = with pkgs.vscode-extensions; [
        aaron-bond.better-comments
        bmewburn.vscode-intelephense-client
        esbenp.prettier-vscode
        foxundermoon.shell-format
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        james-yu.latex-workshop
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
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

      keybindings = [{
        key = "shift+enter";
        command = "-python.execSelectionInTerminal";
      }];

      userSettings = {
        # Editor
        "editor.fontFamily" = "JetBrains Mono";
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
        "cSpell.language" = "en,de";
        "material-icon-theme.activeIconPack" = "react";
        "vim.handleKeys" = { "<C-i>" = false; "<C-k>" = false; "<C-p>" = false; "<C-s>" = true; "<C-z>" = true; };
        "vim.useSystemClipboard" = true;

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.inputValidation" = true;
        "git.openRepositoryInParentFolders" = "always";

        # LaTeX
        "latex-workshop.latex.autoClean.run" = "onSucceeded";

        # PHP
        "intelephense.format.braces" = "k&r";

        # Prettier
        "prettier.arrowParens" = "avoid";
        "prettier.bracketSameLine" = true;
        "prettier.printWidth" = 150;

        # Python
        "autopep8.args" = [ "--indent-size=2" "--max-line-length=150" ];
        "python.analysis.autoFormatStrings" = true;
        "python.analysis.autoImportCompletions" = true;
        "python.analysis.typeCheckingMode" = "standard";

        # Languages
        "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[dockerfile]"."editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };
}
