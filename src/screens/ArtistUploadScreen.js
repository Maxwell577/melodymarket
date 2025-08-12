import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Image,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';
import { colors } from '../theme/theme';
import { StorageService } from '../services/StorageService';

export default function ArtistUploadScreen({ navigation }) {
  const [albumTitle, setAlbumTitle] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [selectedGenre, setSelectedGenre] = useState('Pop');
  const [coverImage, setCoverImage] = useState(null);
  const [tracks, setTracks] = useState([]);
  const [isUploading, setIsUploading] = useState(false);

  const genres = ['Pop', 'Rock', 'Jazz', 'Electronic', 'Hip Hop', 'R&B', 'Country', 'Classical'];

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [1, 1],
      quality: 1,
    });

    if (!result.canceled) {
      setCoverImage(result.assets[0].uri);
    }
  };

  const addTrack = () => {
    Alert.prompt(
      'Add Track',
      'Enter track title:',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Add',
          onPress: (title) => {
            if (title && title.trim()) {
              const newTrack = {
                id: Date.now().toString(),
                title: title.trim(),
                duration: '3:30', // Mock duration
                trackNumber: tracks.length + 1,
              };
              setTracks([...tracks, newTrack]);
            }
          },
        },
      ],
      'plain-text'
    );
  };

  const removeTrack = (trackId) => {
    setTracks(tracks.filter(track => track.id !== trackId));
  };

  const uploadAlbum = async () => {
    if (!albumTitle.trim() || !price || tracks.length === 0) {
      Alert.alert('Error', 'Please fill all required fields and add at least one track');
      return;
    }

    setIsUploading(true);

    try {
      const album = {
        id: Date.now().toString(),
        title: albumTitle.trim(),
        artistId: 'current_artist',
        artistName: 'Current Artist',
        price: parseFloat(price),
        coverImageUrl: coverImage || 'https://picsum.photos/300/300?random=' + Date.now(),
        createdAt: new Date().toISOString(),
        genre: selectedGenre,
        description: description.trim(),
        tracks: tracks.map(track => ({
          ...track,
          artist: 'Current Artist',
          artistId: 'current_artist',
          albumId: Date.now().toString(),
          genre: selectedGenre,
          createdAt: new Date().toISOString(),
        })),
      };

      await StorageService.saveAlbum(album);

      Alert.alert(
        'Success',
        `Album "${album.title}" uploaded successfully!`,
        [{ text: 'OK', onPress: () => {
          // Reset form
          setAlbumTitle('');
          setDescription('');
          setPrice('');
          setCoverImage(null);
          setTracks([]);
          setSelectedGenre('Pop');
        }}]
      );
    } catch (error) {
      Alert.alert('Error', 'Failed to upload album. Please try again.');
    } finally {
      setIsUploading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.headerTitle}>Create Album 🎤</Text>
            <Text style={styles.headerSubtitle}>Share your creativity with the world</Text>
          </View>
          <TouchableOpacity
            style={styles.publishButton}
            onPress={uploadAlbum}
            disabled={isUploading}
          >
            <Text style={styles.publishButtonText}>
              {isUploading ? 'Publishing...' : 'Publish'}
            </Text>
          </TouchableOpacity>
        </View>

        {/* Info Card */}
        <View style={styles.infoCard}>
          <Ionicons name="information-circle-outline" size={20} color={colors.primary} />
          <Text style={styles.infoText}>
            Fill in the details below to create your album. All fields marked with * are required.
          </Text>
        </View>

        {/* Cover Image */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Album Cover *</Text>
          <View style={styles.coverImageSection}>
            <TouchableOpacity style={styles.coverImageContainer} onPress={pickImage}>
              {coverImage ? (
                <Image source={{ uri: coverImage }} style={styles.coverImage} />
              ) : (
                <View style={styles.coverImagePlaceholder}>
                  <Ionicons name="camera" size={40} color={colors.textSecondary} />
                  <Text style={styles.coverImageText}>Add Cover Image</Text>
                </View>
              )}
            </TouchableOpacity>
            <View style={styles.coverImageInfo}>
              <Text style={styles.coverImageTitle}>Choose a cover image</Text>
              <Text style={styles.coverImageDescription}>
                Select an eye-catching image that represents your album.
              </Text>
              <TouchableOpacity style={styles.selectImageButton} onPress={pickImage}>
                <Ionicons name="image" size={18} color={colors.primary} />
                <Text style={styles.selectImageButtonText}>
                  {coverImage ? 'Change Image' : 'Select Image'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>

        {/* Album Title */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Album Title *</Text>
          <TextInput
            style={styles.textInput}
            placeholder="Enter album title"
            value={albumTitle}
            onChangeText={setAlbumTitle}
          />
        </View>

        {/* Genre */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Genre *</Text>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <View style={styles.genreContainer}>
              {genres.map((genre) => (
                <TouchableOpacity
                  key={genre}
                  style={[
                    styles.genreChip,
                    selectedGenre === genre && styles.genreChipActive,
                  ]}
                  onPress={() => setSelectedGenre(genre)}
                >
                  <Text
                    style={[
                      styles.genreChipText,
                      selectedGenre === genre && styles.genreChipTextActive,
                    ]}
                  >
                    {genre}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          </ScrollView>
        </View>

        {/* Price */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Price (USD) *</Text>
          <TextInput
            style={styles.textInput}
            placeholder="9.99"
            value={price}
            onChangeText={setPrice}
            keyboardType="numeric"
          />
        </View>

        {/* Description */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Description</Text>
          <TextInput
            style={[styles.textInput, styles.textArea]}
            placeholder="Describe your album..."
            value={description}
            onChangeText={setDescription}
            multiline
            numberOfLines={3}
          />
        </View>

        {/* Tracks */}
        <View style={styles.section}>
          <View style={styles.tracksHeader}>
            <Text style={styles.sectionTitle}>Tracks ({tracks.length}) *</Text>
            <TouchableOpacity style={styles.addTrackButton} onPress={addTrack}>
              <Ionicons name="add" size={20} color={colors.white} />
              <Text style={styles.addTrackButtonText}>Add Track</Text>
            </TouchableOpacity>
          </View>

          {tracks.length === 0 ? (
            <View style={styles.emptyTracksContainer}>
              <Ionicons name="musical-notes-outline" size={48} color={colors.textSecondary} />
              <Text style={styles.emptyTracksTitle}>No tracks added yet</Text>
              <Text style={styles.emptyTracksSubtitle}>
                Add at least one track to create your album
              </Text>
            </View>
          ) : (
            <View style={styles.tracksList}>
              {tracks.map((track, index) => (
                <View key={track.id} style={styles.trackItem}>
                  <View style={styles.trackNumber}>
                    <Text style={styles.trackNumberText}>{track.trackNumber}</Text>
                  </View>
                  <View style={styles.trackInfo}>
                    <Text style={styles.trackTitle}>{track.title}</Text>
                    <Text style={styles.trackDuration}>Duration: {track.duration}</Text>
                  </View>
                  <TouchableOpacity
                    style={styles.removeTrackButton}
                    onPress={() => removeTrack(track.id)}
                  >
                    <Ionicons name="trash-outline" size={20} color={colors.error} />
                  </TouchableOpacity>
                </View>
              ))}
            </View>
          )}
        </View>

        {/* Upload Button */}
        <TouchableOpacity
          style={[styles.uploadButton, isUploading && styles.uploadButtonDisabled]}
          onPress={uploadAlbum}
          disabled={isUploading}
        >
          <Ionicons name="cloud-upload" size={20} color={colors.white} />
          <Text style={styles.uploadButtonText}>
            {isUploading ? 'Publishing Album...' : 'Publish Album'}
          </Text>
        </TouchableOpacity>

        {/* Guidelines */}
        <View style={styles.guidelinesCard}>
          <View style={styles.guidelinesHeader}>
            <Ionicons name="information-circle-outline" size={16} color={colors.textSecondary} />
            <Text style={styles.guidelinesTitle}>Publishing Guidelines</Text>
          </View>
          <Text style={styles.guidelinesText}>
            • Ensure you own all rights to the music you upload{'\n'}
            • Albums will be reviewed before going live{'\n'}
            • You can edit pricing and details after publishing{'\n'}
            • Earnings are available for withdrawal after 24 hours
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  scrollView: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 16,
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: colors.text,
  },
  headerSubtitle: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  publishButton: {
    backgroundColor: colors.primary,
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
  },
  publishButtonText: {
    color: colors.white,
    fontWeight: '600',
  },
  infoCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
  },
  infoText: {
    flex: 1,
    marginLeft: 12,
    fontSize: 14,
    color: colors.textSecondary,
    lineHeight: 20,
  },
  section: {
    marginHorizontal: 20,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 8,
  },
  coverImageSection: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  coverImageContainer: {
    width: 120,
    height: 120,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: colors.border,
    borderStyle: 'dashed',
    overflow: 'hidden',
  },
  coverImage: {
    width: '100%',
    height: '100%',
  },
  coverImagePlaceholder: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  coverImageText: {
    fontSize: 12,
    color: colors.textSecondary,
    marginTop: 8,
  },
  coverImageInfo: {
    flex: 1,
    marginLeft: 16,
  },
  coverImageTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 4,
  },
  coverImageDescription: {
    fontSize: 14,
    color: colors.textSecondary,
    lineHeight: 20,
    marginBottom: 12,
  },
  selectImageButton: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.primary,
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
    alignSelf: 'flex-start',
  },
  selectImageButtonText: {
    color: colors.primary,
    marginLeft: 4,
    fontWeight: '600',
  },
  textInput: {
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
    fontSize: 16,
    backgroundColor: colors.white,
  },
  textArea: {
    height: 80,
    textAlignVertical: 'top',
  },
  genreContainer: {
    flexDirection: 'row',
    paddingVertical: 8,
  },
  genreChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    marginRight: 8,
  },
  genreChipActive: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  genreChipText: {
    color: colors.text,
    fontSize: 14,
  },
  genreChipTextActive: {
    color: colors.white,
    fontWeight: '600',
  },
  tracksHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  addTrackButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.primary,
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 20,
  },
  addTrackButtonText: {
    color: colors.white,
    marginLeft: 4,
    fontWeight: '600',
  },
  emptyTracksContainer: {
    alignItems: 'center',
    paddingVertical: 40,
    backgroundColor: colors.surface,
    borderRadius: 12,
  },
  emptyTracksTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.textSecondary,
    marginTop: 8,
  },
  emptyTracksSubtitle: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 4,
    textAlign: 'center',
  },
  tracksList: {
    backgroundColor: colors.white,
    borderRadius: 12,
    overflow: 'hidden',
  },
  trackItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  trackNumber: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  trackNumberText: {
    color: colors.white,
    fontWeight: 'bold',
  },
  trackInfo: {
    flex: 1,
  },
  trackTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
  },
  trackDuration: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  removeTrackButton: {
    padding: 8,
  },
  uploadButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    marginHorizontal: 20,
    paddingVertical: 16,
    borderRadius: 12,
    marginBottom: 20,
  },
  uploadButtonDisabled: {
    opacity: 0.6,
  },
  uploadButtonText: {
    color: colors.white,
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  guidelinesCard: {
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    padding: 16,
    borderRadius: 12,
    marginBottom: 40,
  },
  guidelinesHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  guidelinesTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    color: colors.textSecondary,
    marginLeft: 8,
  },
  guidelinesText: {
    fontSize: 12,
    color: colors.textSecondary,
    lineHeight: 18,
  },
});