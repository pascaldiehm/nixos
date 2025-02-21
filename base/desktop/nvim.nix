{ inputs, lib, pkgs, ... }: {
  home-manager.users.pascal = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [ pkgs.ripgrep ];
      extraPlugins = [ pkgs.vimPlugins.plenary-nvim ]; # FIXME: Telescope complained about missing plenary.strings; could have been a bug
      nixpkgs.useGlobalPackages = true;
      vimAlias = true;

      clipboard = {
        providers.wl-copy.enable = true;
        register = "unnamedplus";
      };

      diagnostics = {
        severity_sort = true;
        update_in_insert = true;
      };

      keymaps = lib.mkNvimKeymaps {
        "<C-h>" = [ "<C-Bs>" "t" ];
        "<C-w>" = [ "<C-Bs>" "!" ];
        "<Cmd>Oil<Return>" = [ "<Space><Space>" "n" ];
        "<Cmd>cnext<Return>" = [ "gq" "n" ];
        "<Cmd>cprevious<Return>" = [ "gQ" "n" ];
        "<Cmd>new<Return>" = [ "<A-S-w>" "n" ];
        "<Cmd>tab new<Return>" = [ "<A-t>" "n" ];
        "<Cmd>tabnext<Return>" = [ "<A-Tab>" "n" ];
        "<Cmd>tabprevious<Return>" = [ "<A-S-Tab>" "n" ];
        "<Cmd>terminal<Return>i" = [ "<Space><Return>" "n" ];
        "<Cmd>vertical new<Return>" = [ "<A-w>" "n" ];
        "<Cmd>wincmd H<Return>" = [ "<A-S-h>" "n" ];
        "<Cmd>wincmd J<Return>" = [ "<A-S-j>" "n" ];
        "<Cmd>wincmd K<Return>" = [ "<A-S-k>" "n" ];
        "<Cmd>wincmd L<Return>" = [ "<A-S-l>" "n" ];
        "<Cmd>wincmd h<Return>" = [ "<A-h>" "n" ];
        "<Cmd>wincmd j<Return>" = [ "<A-j>" "n" ];
        "<Cmd>wincmd k<Return>" = [ "<A-k>" "n" ];
        "<Cmd>wincmd l<Return>" = [ "<A-l>" "n" ];
      };

      opts = {
        expandtab = true;
        hlsearch = false;
        ignorecase = true;
        mouse = "";
        number = true;
        relativenumber = true;
        scrolloff = 8;
        shiftwidth = 2;
        signcolumn = "yes";
        smartcase = true;
        softtabstop = 2;
        splitbelow = true;
        splitright = true;
        tabstop = 2;
        wrap = false;
      };

      performance = {
        combinePlugins.enable = true;

        byteCompileLua = {
          enable = true;
          nvimRuntime = true;
          plugins = true;
        };
      };

      plugins = {
        autoclose.enable = true;
        comment.enable = true;
        gitsigns.enable = true;
        lualine.enable = true;
        nvim-surround.enable = true;
        web-devicons.enable = true;

        cmp = {
          enable = true;

          settings = {
            sources = [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];

            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<S-Tab>" = "cmp.mapping.select_prev_item()";
              "<Tab>" = "cmp.mapping.select_next_item()";
            };
          };
        };

        conform-nvim = {
          enable = true;

          settings = {
            format_on_save.lsp_format = "never";

            formatters = {
              clang-format.command = lib.getExe' pkgs.clang-tools "clang-format";
              google-java-format.command = lib.getExe pkgs.google-java-format;

              bibtex-tidy = {
                command = lib.getExe pkgs.bibtex-tidy;
                prepend_args = [ "--wrap" "120" ];
              };

              black = {
                command = lib.getExe pkgs.python3Packages.black;
                prepend_args = [ "-l" "120" ];
              };

              cmake_format = {
                command = lib.getExe pkgs.cmake-format;
                prepend_args = [ "--line-width" "120" "--tab-size" "2" ];
              };

              latexindent = {
                command = lib.getExe' pkgs.texlivePackages.latexindent "latexindent";
                prepend_args = [ "--logfile" "/dev/null" ];
              };

              nixfmt = {
                command = lib.getExe pkgs.nixfmt-rfc-style;
                prepend_args = [ "-w" "120" "-s" ];
              };

              prettier = {
                command = lib.getExe pkgs.nodePackages.prettier;
                prepend_args = [ "--arrow-parens" "avoid" "--print-width" "120" ];
              };

              shfmt = {
                command = lib.getExe pkgs.shfmt;
                prepend_args = [ "-i" "2" ];
              };
            };

            formatters_by_ft = {
              bib = [ "bibtex-tidy" ];
              c = [ "clang-format" ];
              cmake = [ "cmake_format" ];
              cpp = [ "clang-format" ];
              css = [ "prettier" ];
              html = [ "prettier" ];
              java = [ "google-java-format" ];
              javascript = [ "prettier" ];
              javascriptreact = [ "prettier" ];
              json = [ "prettier" ];
              markdown = [ "prettier" ];
              nix = [ "nixfmt" ];
              plaintex = [ "latexindent" ];
              python = [ "black" ];
              scss = [ "prettier" ];
              sh = [ "shfmt" ];
              tex = [ "latexindent" ];
              typescript = [ "prettier" ];
              typescriptreact = [ "prettier" ];
              yaml = [ "prettier" ];
              zsh = [ "shfmt" ];
            };
          };
        };

        lsp = {
          enable = true;

          keymaps = {
            diagnostic = {
              gP = "goto_prev";
              gp = "goto_next";
            };

            lspBuf = {
              gc = "code_action";
              gd = "definition";
              gh = "hover";
              gi = "implementation";
              gr = "rename";
            };
          };

          servers = {
            bashls.enable = true;
            clangd.enable = true;
            cmake.enable = true;
            cssls.enable = true;
            docker_compose_language_service.enable = true;
            dockerls.enable = true;
            eslint.enable = true;
            html.enable = true;
            java_language_server.enable = true;
            nixd.enable = true;
            phpactor.enable = true;
            pylsp.enable = true;
            tailwindcss.enable = true;
            texlab.enable = true;
            ts_ls.enable = true;
          };
        };

        oil = {
          enable = true;

          settings = {
            use_default_keymaps = false;
            view_options.show_hidden = true;

            keymaps = {
              "<Bs>" = "actions.parent";
              "<Return>" = "actions.select";
              q = "actions.close";
            };
          };
        };

        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;

          keymaps = {
            "<Space>f" = "find_files hidden=true no_ignore=true";
            "<Space>g" = "live_grep";
            "<Space>p" = "diagnostics";
            "<Space>q" = "quickfix";
            "<Space>r" = "lsp_references";
            "<Space>s" = "lsp_workspace_symbols";
          };

          settings.defaults = {
            file_ignore_patterns = [ "^.git/" ];

            mappings.i = {
              "<A-S-q>".__raw = "require('telescope.actions').smart_add_to_qflist";
              "<A-q>".__raw = "require('telescope.actions').smart_send_to_qflist";
              "<Esc>".__raw = "require('telescope.actions').close";
              "<S-Return>".__raw = "require('telescope.actions').file_tab";
            };

            vimgrep_arguments = [
              "rg"
              "--color=never"
              "--column"
              "--hidden"
              "--line-number"
              "--no-heading"
              "--no-ignore"
              "--smart-case"
              "--with-filename"
            ];
          };
        };

        treesitter = {
          enable = true;

          settings = {
            highlight.enable = true;
            indent.enable = true;

            incremental_selection = {
              enable = true;

              keymaps = {
                init_selection = "<A-v>";
                node_decremental = "<A-->";
                node_incremental = "<A-+>";
                scope_incremental = false;
              };
            };
          };
        };
      };
    };
  };
}
