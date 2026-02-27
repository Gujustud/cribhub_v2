// Git information - updated manually or via script
// Latest commit info as of: 2025-02-23

class GitInfo {
  static const String commitHash = '938229a3e9c5ca81d73bb797a9c6fbaa75e2cb7e';
  static const String shortHash = '938229a';
  static const String commitMessage = 'UI and local dev: inventory list tweaks, brands/suppliers cleanup, localhost config';
  static const String branch = 'main';
  static const String repositoryUrl = 'https://github.com/gujustud/cribhub_v2';
  
  // GitHub commit URL
  static String get commitUrl => '$repositoryUrl/commit/$commitHash';
  
  // GitHub repository URL
  static String get repoUrl => repositoryUrl;
}
