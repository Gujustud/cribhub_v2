// Git information - updated manually or via script
// Latest commit info as of: 2025-01-24

class GitInfo {
  static const String commitHash = 'ec5286e25731785701afad24d38dd1c2db98ffdf';
  static const String shortHash = 'ec5286e2';
  static const String commitMessage = 'feat: UI improvements, searchable dropdowns, location redesign, and subcategory labeling system';
  static const String branch = 'main';
  static const String repositoryUrl = 'https://github.com/gujustud/cribhub_v2';
  
  // GitHub commit URL
  static String get commitUrl => '$repositoryUrl/commit/$commitHash';
  
  // GitHub repository URL
  static String get repoUrl => repositoryUrl;
}
