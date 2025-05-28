{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.pascal = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      extraFiles."spell/de.utf-8.spl".source = ../../resources/de.utf-8.spl;
      extraPackages = [ pkgs.ripgrep ];
      extraPlugins = [ pkgs.vimPlugins.plenary-nvim ];
      nixpkgs.useGlobalPackages = true;

      clipboard = {
        providers.wl-copy.enable = true;
        register = "unnamedplus";
      };

      diagnostic.settings = {
        severity_sort = true;
        update_in_insert = true;
      };

      keymaps = lib.mkNvimKeymaps {
        "!"."<C-Bs>" = "<C-w>";
        t."<C-Bs>" = "<C-h>";

        n = {
          "<C-d>" = "<C-d>zz";
          "<C-u>" = "<C-u>zz";
          "<Space><Return>" = "<Cmd>terminal<Return>i";
          "<Space><Space>" = "<Cmd>Oil<Return>";
          gQ = "<Cmd>cprevious<Return>";
          gq = "<Cmd>cnext<Return>";
        };

        nt = {
          "<A-S-Tab>" = "<Cmd>tabprevious<Return>";
          "<A-S-h>" = "<Cmd>wincmd H<Return>";
          "<A-S-j>" = "<Cmd>wincmd J<Return>";
          "<A-S-k>" = "<Cmd>wincmd K<Return>";
          "<A-S-l>" = "<Cmd>wincmd L<Return>";
          "<A-S-w>" = "<Cmd>new<Return>";
          "<A-Tab>" = "<Cmd>tabnext<Return>";
          "<A-h>" = "<Cmd>wincmd h<Return>";
          "<A-j>" = "<Cmd>wincmd j<Return>";
          "<A-k>" = "<Cmd>wincmd k<Return>";
          "<A-l>" = "<Cmd>wincmd l<Return>";
          "<A-t>" = "<Cmd>tab new<Return>";
          "<A-w>" = "<Cmd>vertical new<Return>";
        };

        x = {
          "<S-Tab>" = "<gv";
          "<Tab>" = ">gv";
        };
      };

      opts = {
        expandtab = true;
        hlsearch = false;
        ignorecase = true;
        mouse = "";
        number = true;
        relativenumber = true;
        scrolloff = 8;
        shell = "${lib.getExe config.users.users.pascal.shell} -i";
        shiftwidth = 2;
        signcolumn = "yes";
        smartcase = true;
        softtabstop = 2;
        spelllang = "en,de";
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
        comment.enable = true;
        gitsigns.enable = true;
        lualine.enable = true;
        nvim-surround.enable = true;
        ts-autotag.enable = true;
        web-devicons.enable = true;

        autoclose = {
          enable = true;

          settings.keys = {
            ">" = {
              close = false;
              escape = false;
              pair = "><";
            };
          };
        };

        cmp = {
          enable = true;

          settings = {
            sources = [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];

            mapping = {
              "<C-Return>" = "cmp.mapping.confirm()";
              "<C-Space>" = "cmp.mapping.complete()";
              "<S-Tab>" = "cmp.mapping.select_prev_item()";
              "<Tab>" = "cmp.mapping.select_next_item()";
            };
          };
        };

        conform-nvim = {
          enable = true;

          settings = {
            format_on_save.lsp_format = "fallback";

            formatters = lib.mkNvimFormatters {
              bibtex-tidy = [ (lib.getExe pkgs.bibtex-tidy) "--wrap" "120" ];
              black = [ (lib.getExe pkgs.python3Packages.black) "-l" "120" ];
              clang-format = [ (lib.getExe' pkgs.clang-tools "clang-format") ];
              cmake_format = [ (lib.getExe pkgs.cmake-format) "--line-width" "120" "--tab-size" "2" ];
              google-java-format = [ (lib.getExe pkgs.google-java-format) ];
              latexindent = [ (lib.getExe' pkgs.texlivePackages.latexindent "latexindent") "--logfile" "/dev/null" ];
              nixfmt = [ (lib.getExe pkgs.nixfmt-rfc-style) "-s" "-w" "120" ];
              prettier = [ (lib.getExe pkgs.nodePackages.prettier) "--arrow-parens" "avoid" "--print-width" "120" ];
              shfmt = [ (lib.getExe pkgs.shfmt) "-i" "2" ];
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
              gr = "empty_rename";
            };
          };

          postConfig = ''
            vim.lsp.buf.empty_rename = function()
              vim.ui.input({ prompt = "New Name: " }, function(name)
                vim.lsp.buf.rename(name)
              end)
            end
          '';

          servers = {
            bashls.enable = true;
            clangd.enable = true;
            cmake.enable = true;
            cssls.enable = true;
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
            "<Space>f" = "find_files hidden=true";
            "<Space>g" = "live_grep";
            "<Space>p" = "diagnostics";
            "<Space>q" = "quickfix";
            "<Space>r" = "lsp_references";
            "<Space>s" = "lsp_workspace_symbols";
          };

          settings.defaults = {
            file_ignore_patterns = [ "^.git/" ];

            mappings.i = {
              "<A-Return>".__raw = "require('telescope.actions').file_tab";
              "<A-S-q>".__raw = "require('telescope.actions').smart_add_to_qflist";
              "<A-q>".__raw = "require('telescope.actions').smart_send_to_qflist";
              "<Esc>".__raw = "require('telescope.actions').close";
              "<S-Return>".__raw = "require('telescope.actions').file_vsplit";
            };

            vimgrep_arguments = [
              "rg"
              "--color=never"
              "--column"
              "--hidden"
              "--line-number"
              "--no-heading"
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
