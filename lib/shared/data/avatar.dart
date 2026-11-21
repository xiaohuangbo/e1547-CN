/// Builds the URL for a user's server-side cropped avatar.
///
/// Cropped avatars live on the same host as post files, so the host is taken
/// from [reference] (any media URL of the avatar post) by replacing everything
/// from `/data/` onwards. [avatarId] is appended as a cache-busting token so a
/// changed avatar is refetched. Returns null when [reference] has no `/data/`
/// segment to anchor the host.
String? croppedAvatarUrl({
  required String reference,
  required int userId,
  required int avatarId,
}) {
  int index = reference.indexOf('/data/');
  if (index == -1) return null;
  return '${reference.substring(0, index)}/data/avatars/$userId.jpg?t=$avatarId';
}
