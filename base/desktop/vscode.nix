{
  lib,
  pkgs,
  system,
  ...
}:
{
  home-manager.users.pascal.programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;

    extensions =
      with pkgs.vscode-extensions;
      [
        aaron-bond.better-comments
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        editorconfig.editorconfig
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
        redhat.java
        streetsidesoftware.code-spell-checker
        twxs.cmake
        usernamehw.errorlens
        vscodevim.vim
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (lib.importJSON ../../resources/extensions/vscode.json);

    keybindings = lib.mapAttrsToList (key: command: { inherit key command; }) {
      "shift+enter" = "-python.execSelectionInTerminal";
    };

    userSettings = {
      # Editor
      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlayHints.enabled" = "off";
      "editor.lineNumbers" = "relative";
      "editor.linkedEditing" = true;
      "editor.tabSize" = 2;
      "explorer.compactFolders" = false;
      "extensions.experimental.affinity"."vscode.vim" = 1;
      "extensions.ignoreRecommendations" = true;
      "files.enableTrash" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.showExitAlert" = false;
      "update.showReleaseNotes" = false;
      "workbench.editorAssociations"."*.pdf" = "latex-workshop-pdf-hook";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";

      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "always";
        "source.removeUnusedImports" = "always";
        "source.sortImports" = "always";
      };

      # General
      "cSpell.diagnosticLevel" = "Hint";
      "cSpell.language" = "en,de";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.inputValidation" = true;
      "git.openRepositoryInParentFolders" = "always";
      "material-icon-theme.activeIconPack" = "react";
      "vim.useSystemClipboard" = true;

      "vim.handleKeys" = {
        "<C-i>" = false;
        "<C-k>" = false;
        "<C-p>" = false;
        "<C-s>" = true;
        "<C-z>" = true;
      };

      # C++
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "cmake.configureOnOpen" = true;

      # Java
      "java.compile.nullAnalysis.mode" = "automatic";
      "java.configuration.updateBuildConfiguration" = "automatic";
      "java.format.settings.url" = ../../resources/java-format.xml;
      "redhat.telemetry.enabled" = false;

      # LaTeX
      "latex-workshop.latex.autoClean.run" = "onSucceeded";

      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";

      "nix.serverSettings".nixd = {
        nixpkgs.expr = "import (builtins.getFlake \"\${workspaceFolder}\").inputs.nixpkgs {}";
        options.nixos.expr = "(builtins.getFlake \"/home/pascal/.config/nixos\").nixosConfigurations.${system.name}.options";

        formatting.command = [
          "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
          "-w"
          "120"
        ];
      };

      # PHP
      "intelephense.format.braces" = "k&r";

      # Prettier
      "prettier.arrowParens" = "avoid";
      "prettier.bracketSameLine" = true;
      "prettier.printWidth" = 120;

      # Python
      "autopep8.args" = [
        "--indent-size=2"
        "--max-line-length=120"
      ];

      # Formatters
      "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[dockerfile]"."editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";
    };
  };
}
