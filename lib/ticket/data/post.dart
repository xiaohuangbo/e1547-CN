/// This should be replaced by a FilterList.
/// To do that, we need to upgrade FilterList to support required fields.
// TODO: Replace this with a FilterList
library;

enum PostReportType {
  rating,
  file,
  source,
  description,
  note,
  tagging;

  int get id => switch (this) {
    rating => 6,
    file => 5,
    source => 4,
    description => 3,
    note => 2,
    tagging => 1,
  };

  String get title => switch (this) {
    rating => 'Rating Abuse',
    file => 'Malicious File',
    source => 'Malicious Source',
    description => '描述滥用',
    note => 'Note Abuse',
    tagging => 'Tagging Abuse',
  };

  String get body => switch (this) {
    rating =>
      'The rating of the submission has been set to something incorrect.',
    file =>
      'The file contains either malicious code or contains a hidden file archive. This is not for imagery depicted in the image itself.',
    source =>
      'One or more of the listed sources link to malicious pages or pay content.',
    description => '该描述包含恶意内容，或被编辑为包含滥用材料。',
    note =>
      'The notes on this post are wrong, harassive, or otherwise abusive.',
    tagging =>
      'One or more tags on this post aren\'t valid or one or more valid tags have been removed from this post.',
  };
}
