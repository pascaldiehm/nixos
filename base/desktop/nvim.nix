{ inputs, lib, pkgs, system, ... }: {
  home-manager.users.pascal = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;

      autoCmd = lib.singleton {
        command = "setlocal formatoptions-=o shiftwidth< softtabstop< tabstop< textwidth<";
        event = "FileType";
      };

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

        {
          action = "\"_dP";
          key = "p";
          mode = "x";
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

        lsp = {
          enable = true;

          keymaps.lspBuf = {
            "<F2>" = "rename";
            gd = "definition";
            gh = "hover";
            gi = "implementation";
            gs = "signature_help";
          };

          onAttach = ''
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false, id = client.id }
              end
            });
          '';

          servers = {
            bashls.enable = true;
            clangd.enable = true;
            cmake.enable = true;
            docker_compose_language_service.enable = true;
            dockerls.enable = true;
            eslint.enable = true;
            html.enable = true;
            jsonls.enable = true;
            pylsp.enable = true;
            sqls.enable = true;
            texlab.enable = true;
            ts_ls.enable = true;

            nixd = {
              enable = true;

              settings = {
                formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) "-s" "-w" "120" ];
                nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}";
                options.nixos.expr = "(builtins.getFlake \"/home/pascal/.config/nixos\").nixosConfigurations.${system.name}.options";
              };
            };
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
          extensions.live-grep-args.enable = true;

          keymaps = {
            "<Space>f" = "find_files";
            "<Space>g" = "live_grep";
            "<Space>p" = "diagnostics";
            "<Space>r" = "lsp_references";
            "<Space>s" = "lsp_workspace_symbols";
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
