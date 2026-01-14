{ inputs, lib, machine, pkgs, ... }: {
  home-manager.users.pascal = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      extraConfigLua = lib.readFile ../../resources/vim/nvim.lua;
      filetype.extension.zsh = "sh";
      nixpkgs.useGlobalPackages = true;

      autoCmd = lib.mapAttrsToList (event: command: { inherit command event; }) {
        TermClose = "lua if vim.v.event.status ~= 0 then vim.api.nvim_input('<Return>') end";
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
          vv = "gv";
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

      lsp = {
        keymaps = lib.mkNvimKeymaps {
          i."<A-Space>".__raw = "vim.lsp.buf.signature_help";

          n = {
            gP.__raw = "vim.diagnostic.goto_prev";
            ga.__raw = "vim.lsp.buf.code_action";
            gd.__raw = "vim.lsp.buf.definition";
            gh.__raw = "vim.lsp.buf.hover";
            gi.__raw = "vim.lsp.buf.implementation";
            gp.__raw = "vim.diagnostic.goto_next";
            gr.__raw = "vim.lsp.buf.empty_rename";
          };
        };

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

          gdscript = {
            enable = true;

            config = {
              cmd.__raw = "vim.lsp.rpc.connect('127.0.0.1', 6005)";
              filetypes = [ "gdscript" ];
              root_markers = [ "project.godot" ];
            };
          };

          nixd = {
            enable = true;

            config.settings.nixd = {
              nixpkgs.expr = ''(builtins.getFlake "/home/pascal/.config/nixos").nixosConfigurations."${machine.name}".pkgs'';
              options.nixos.expr = ''(builtins.getFlake "/home/pascal/.config/nixos").nixosConfigurations."${machine.name}".options'';
            };
          };

          rust_analyzer = {
            enable = true;
            config.settings.rust-analyzer.check.command = "clippy";
          };
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
        shell = "${lib.getExe pkgs.zsh} --interactive";
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
          # enable = true; # HACK: => treesitter
          standalonePlugins = [ "onedark.nvim" ];
        };
      };

      plugins = {
        comment.enable = true;
        lspconfig.enable = true;
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
              gdformat = [ (lib.getExe' pkgs.gdtoolkit_4 "gdformat") "--line-length=120" ];
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
              gdscript = [ "gdformat" ];
              html = [ "prettier" ];
              java = [ "google-java-format" ];
              javascript = [ "prettier" ];
              javascriptreact = [ "prettier" ];
              json = [ "prettier" ];
              jsonc = [ "prettier" ];
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
              xml = [ "prettier" ];
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
            "<Space>h" = "help_tags";
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
              "<A-Return>".__raw = "require('telescope.actions').select_tab";
              "<A-S-q>".__raw = "require('telescope.actions').smart_add_to_qflist";
              "<A-q>".__raw = "require('telescope.actions').smart_send_to_qflist";
              "<Esc>".__raw = "require('telescope.actions').close";
              "<S-Return>".__raw = "require('telescope.actions').select_vertical";
            };

            vimgrep_arguments = [
              "rg"
              "--color=never"
              "--column"
              "--hidden"
              "--line-number"
              "--no-heading"
              "--pcre2"
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

        # HACK: https://github.com/NixOS/nixpkgs/issues/478561
        treesitter = {
          enable = true;
          package = pkgs.vimPlugins.nvim-treesitter-legacy;

          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
      };
    };
  };
}
