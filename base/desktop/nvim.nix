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

      keymaps = [
        {
          action = "<C-w>";
          key = "<C-Bs>";
          mode = "!";
        }

        {
          action = "<Cmd>Oil<Return>";
          key = "<Space><Space>";
          mode = "n";
        }

        {
          action = "<Cmd>cnext<Return>";
          key = "gq";
          mode = "n";
        }

        {
          action = "<Cmd>cprev<Return>";
          key = "gQ";
          mode = "n";
        }

        {
          action = "<Cmd>new<Return>";
          key = "<A-S-w>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>tab new<Return>";
          key = "<A-t>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>tabnext<Return>";
          key = "<A-Tab>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>tabprevious<Return>";
          key = "<A-S-Tab>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>terminal<Return>i";
          key = "<Space><Return>";
          mode = "n";
        }

        {
          action = "<Cmd>vertical new<Return>";
          key = "<A-w>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd H<Return>";
          key = "<A-S-h>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd J<Return>";
          key = "<A-S-j>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd K<Return>";
          key = "<A-S-k>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd L<Return>";
          key = "<A-S-l>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd h<Return>";
          key = "<A-h>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd j<Return>";
          key = "<A-j>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd k<Return>";
          key = "<A-k>";
          mode = [ "n" "x" ];
        }

        {
          action = "<Cmd>wincmd l<Return>";
          key = "<A-l>";
          mode = [ "n" "x" ];
        }
      ];

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
