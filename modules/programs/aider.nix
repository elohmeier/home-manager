{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aider;
  yamlFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = [ hm.maintainers.elohmeier ];

  options.programs.aider = {
    enable = mkEnableOption "AI pair programming in your terminal";

    package = mkPackageOption pkgs "aider-chat" { };

    settings = mkOption {
      type = yamlFormat.type;
      default = { };
      defaultText = literalExpression "{ }";
      example = literalExpression ''
        {
          check-update = false;
          suggest-shell-commands = false;
        }
      '';
      description = ''
        Configuration written to {file}`$HOME/.aider.conf.yml`.
        See <https://aider.chat/docs/config/aider_conf.html> for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".aider.conf.yml" = mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "aider-config" cfg.settings;
    };
  };
}
