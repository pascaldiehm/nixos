{ lib, pkgs, ... }: {
  home-manager.users.pascal = {
    fonts.fontconfig.enable = true;
    home.packages = [ pkgs.jetbrains-mono ];

    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace (lib.importJSON ../../resources/extensions/vscode.json);
      keybindings = [{ key = "shift+enter"; command = "-python.execSelectionInTerminal"; }];
      mutableExtensionsDir = false;
      package = pkgs.vscodium;

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
        "cSpell.enabledFileTypes" = { "*" = true; };
        "material-icon-theme.activeIconPack" = "react";
        "tabnine.codeLensEnabled" = false;
        "tabnine.experimentalAutoImports" = true;
        "vim.handleKeys" = { "<C-i>" = false; "<C-k>" = false; "<C-p>" = false; "<C-s>" = true; "<C-z>" = true; };
        "vim.useSystemClipboard" = true;

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.inputValidation" = true;
        "git.openRepositoryInParentFolders" = "always";

        # C++
        "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
        "cmake.pinnedCommands" = [ "workbench.action.tasks.configureTaskRunner" "workbench.action.tasks.runTask" ];

        # LaTeX
        "latex-workshop.formatting.latex" = "latexindent";
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
  };
}
