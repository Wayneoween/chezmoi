---@diagnostic disable: undefined-global
-- Filetype detection. Patterns are Lua patterns matched against the full path
-- (so `%.` is a literal dot and `%-` a literal dash).
vim.filetype.add {
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    tfstate = "json",
  },
  filename = {
    [".gitlab-ci.yml"] = "yaml.gitlab",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".*/docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
    [".*/ansible/hosts/.*%.ya?ml"] = "yaml.ansible",
    [".*/openapi[^/]*%.ya?ml"] = "yaml.openapi",
    [".*/openapi[^/]*%.json"] = "json.openapi",
  },
}
