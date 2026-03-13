rec {
  hostname = "...";

  full_name = "...";
  username = "...";
  work_email = "...";

  defaults = {
    git = {
      name = full_name;
      email = work_email;
      signingKey = "ssh-ed25519 ...";

      azRepos = {
#       EXAMPLE:
#       "azrepos:org/ADO_ORG" = {
#         azureAuthority = "https://login.microsoftonline.com/TENANT_UUID";
#         username = work_email;
#       }
      };
    };
  };

  tls = {
    trustedCAs = [
      "-----BEGIN CERTIFICATE-----...-----END CERTIFICATE-----"
      "-----BEGIN CERTIFICATE-----...-----END CERTIFICATE-----"
    ];
  };

  # Computed properties
  home = "/Users/${username}";
}
