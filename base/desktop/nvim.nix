{ config, inputs, lib, machine, pkgs, ... }: {
  home-manager.users.pascal = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      filetype.extension.zsh = "sh";
      nixpkgs.useGlobalPackages = true;

      autoCmd = lib.mapAttrsToList (event: command: { inherit command event; }) {
        TermClose = "lua if vim.v.event.status ~= 0 then vim.api.nvim_input(\"<Return>\") end";
        TermOpen = "setlocal nospell";
      };

      clipboard = {
        providers.wl-copy.enable = true;
        register = "unnamedplus";
      };

      colorschemes.onedark = {
        enable = true;

        settings = {
          term_colors = false;
          transparent = true;
        };
      };

      diagnostic.settings = {
        severity_sort = true;
        update_in_insert = true;
        virtual_text = true;
      };

      extraConfigLua = ''
        vim.keymap.del("n", "gra");
        vim.keymap.del("n", "gri");
        vim.keymap.del("n", "grn");
        vim.keymap.del("n", "grr");
        vim.keymap.del("n", "grt");

        vim.keymap.set("i", ";", function()
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local ctx = line:sub(col, col + 1)

          if ctx == "()" or ctx == "[]" or ctx == "{}" then
            return "<Esc>la;<Esc>hi"
          else
            return ";"
          end
        end, { expr = true, noremap = true })
      '';

      extraFiles = {
        "spell/de.utf-8.spl".source = ../../resources/vim/de.utf-8.spl;
        "spell/de.utf-8.sug".source = ../../resources/vim/de.utf-8.sug;
        "spell/en.utf-8.spl".source = ../../resources/vim/en.utf-8.spl;
        "spell/en.utf-8.sug".source = ../../resources/vim/en.utf-8.sug;
      };

      keymaps = lib.mkNvimKeymaps {
        "!"."<C-Bs>" = "<C-w>";
        nx.x = "\"_x";

        n = {
          "<Space><Return>" = "<Cmd>terminal<Return>i";
          "<Space><Space>" = "<Cmd>Oil<Return>";
          X = "\"_D";
          gQ = "<Cmd>cprevious<Return>";
          gl = "<C-o>";
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

        t = {
          "<C-Bs>" = "<C-h>";
          "<A-Esc>" = "<C-\\><C-n>";
        };

        x = {
          H = "<gv";
          J = ":m '>+1<Return>gv=gv";
          K = ":m '<-2<Return>gv=gv";
          L = ">gv";
          O = ":sort<Return>";
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
        shell = "${lib.getExe config.users.users.pascal.shell} --interactive";
        shiftwidth = 2;
        signcolumn = "yes";
        smartcase = true;
        smartindent = true;
        softtabstop = 2;
        spell = true;
        spelllang = "en,de";
        splitbelow = true;
        splitright = true;
        tabstop = 2;
        wrap = false;
      };

      performance = {
        byteCompileLua = {
          enable = true;
          luaLib = true;
          nvimRuntime = true;
          plugins = true;
        };

        combinePlugins = {
          enable = true;
          standalonePlugins = [ "onedark.nvim" ];
        };
      };

      plugins = {
        comment.enable = true;
        lualine.enable = true;
        nvim-surround.enable = true;
        ts-autotag.enable = true;
        web-devicons.enable = true;

        autoclose = {
          enable = true;

          settings.keys = {
            "'".close = false;
            ">".pair = "><";
          };
        };

        cmp = {
          enable = true;

          settings = {
            preselect = "cmp.PreselectMode.None";
            sources = [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];

            mapping = {
              "<C-Return>" = "cmp.mapping.confirm({ select = true })";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(8)";
              "<C-u>" = "cmp.mapping.scroll_docs(-8)";
              "<S-Tab>" = "cmp.mapping.select_prev_item()";
              "<Tab>" = "cmp.mapping.select_next_item()";
            };
          };
        };

        conform-nvim = {
          enable = true;

          settings = {
            format_on_save.lsp_format = "never";

            formatters = lib.mkNvimFormatters {
              black = [ (lib.getExe pkgs.python3Packages.black) "--line-length=120" ];
              clang-format = [ (lib.getExe' pkgs.clang-tools "clang-format") ];
              cmake-format = [ (lib.getExe pkgs.cmake-format) "--autosort" "--line-width=120" "--tab-size=2" ];
              dockerfmt = [ (lib.getExe pkgs.dockerfmt) "--indent=2" "--newline" ];
              google-java-format = [ (lib.getExe pkgs.google-java-format) ];
              isort = [ (lib.getExe pkgs.python3Packages.isort) ];
              nixfmt = [ (lib.getExe pkgs.nixfmt) "--strict" "--width=120" ];
              rustfmt = [ (lib.getExe pkgs.rustfmt) ];
              shfmt = [ (lib.getExe pkgs.shfmt) "--indent=2" ];

              bibtex-tidy = [
                (lib.getExe pkgs.bibtex-tidy)
                "--blank-lines"
                "--merge"
                "--no-escape"
                "--numeric"
                "--remove-empty-fields"
                "--sort"
                "--sort-fields"
                "--trailing-commas"
                "--wrap=120"
              ];

              latexindent = [
                (lib.getExe' pkgs.texlivePackages.latexindent "latexindent")
                "--local=${../../resources/latexindent.yaml}"
                "--logfile=/dev/null"
              ];

              prettier = [
                (lib.getExe pkgs.prettier)
                "--arrow-parens=avoid"
                "--brace-style=1tbs"
                "--print-width=120"
                "--tab-width=2"
              ];
            };

            formatters_by_ft = {
              bib = [ "bibtex-tidy" ];
              c = [ "clang-format" ];
              cmake = [ "cmake-format" ];
              cpp = [ "clang-format" ];
              css = [ "prettier" ];
              dockerfile = [ "dockerfmt" ];
              html = [ "prettier" ];
              java = [ "google-java-format" ];
              javascript = [ "prettier" ];
              javascriptreact = [ "prettier" ];
              json = [ "prettier" ];
              markdown = [ "prettier" ];
              nix = [ "nixfmt" ];
              php = [ "prettier" ];
              python = [ "isort" "black" ];
              rust = [ "rustfmt" ];
              scss = [ "prettier" ];
              sh = [ "shfmt" ];
              tex = [ "latexindent" ];
              typescript = [ "prettier" ];
              typescriptreact = [ "prettier" ];
              yaml = [ "prettier" ];
            };
          };
        };

        gitsigns = {
          enable = true;

          settings = {
            current_line_blame = true;
            current_line_blame_opts.delay = 250;
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
              ga = "code_action";
              gd = "definition";
              gh = "hover";
              gi = "implementation";
              gr = "empty_rename";
            };
          };

          luaConfig.content = ''
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
            jsonls.enable = true;
            phpactor.enable = true;
            pylsp.enable = true;
            tailwindcss.enable = true;
            texlab.enable = true;
            ts_ls.enable = true;
            yamlls.enable = true;

            nixd = {
              enable = true;
              settings.options.nixos.expr = "(builtins.getFlake \"/home/pascal/.config/nixos\").nixosConfigurations.${machine.name}.options";
            };

            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
              settings.check.command = "clippy";
            };
          };
        };

        oil = {
          enable = true;

          settings = {
            skip_confirm_for_simple_edits = true;
            use_default_keymaps = false;
            view_options.show_hidden = true;

            keymaps = {
              "<Bs>" = "actions.parent";
              "<Return>" = "actions.select";
              "~" = "actions.cd";
              _ = "actions.open_cwd";
              q = "actions.close";
            };
          };
        };

        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;

          keymaps = {
            "<Space>a" = "spell_suggest";
            "<Space>b" = "buffers";
            "<Space>c" = "git_commits";
            "<Space>d" = "lsp_document_symbols";
            "<Space>f" = "find_files hidden=true";
            "<Space>g" = "live_grep";
            "<Space>l" = "resume";
            "<Space>p" = "diagnostics";
            "<Space>q" = "quickfix";
            "<Space>r" = "lsp_references";
            "<Space>s" = "git_status";
            "<Space>w" = "grep_string";
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

        todo-comments = {
          enable = true;
          keymaps.todoTelescope.key = "<Space>t";

          settings = {
            search.args = [ "--color=never" "--column" "--hidden" "--line-number" "--no-heading" "--smart-case" "--with-filename" ];

            highlight = {
              after = "";
              keyword = "fg";
            };
          };
        };

        toggleterm = {
          enable = true;

          settings = {
            open_mapping = "[[<A-Return>]]";
            size = 8;
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
