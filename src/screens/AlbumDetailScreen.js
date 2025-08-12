import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../theme/theme';
import { StorageService } from '../services/StorageService';

export default function AlbumDetailScreen({ route, navigation }) {
  const { album, isPurchased: initialPurchased = false } = route.params;
  const [isPurchased, setIsPurchased] = useState(initialPurchased);

  useEffect(() => {
    checkPurchaseStatus();
  }, []);

  const checkPurchaseStatus = async () => {
    try {
      const user = await StorageService.getCurrentUser();
      if (user && user.purchasedAlbums.includes(album.id)) {
        setIsPurchased(true);
      }
    } catch (error) {
      console.error('Error checking purchase status:', error);
    }
  };

  const purchaseAlbum = async () => {
    Alert.alert(
      'Purchase Album',
      `Purchase "${album.title}" by ${album.artistName} for $${album.price}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Purchase',
          onPress: async () => {
            try {
              await StorageService.purchaseAlbum(album.id);
              setIsPurchased(true);
              Alert.alert('Success', `Successfully purchased "${album.title}"!`);
            } catch (error) {
              Alert.alert('Error', 'Failed to purchase album. Please try again.');
            }
          },
        },
      ]
    );
  };

  const playTrack = (track) => {
    if (!isPurchased) {
      Alert.alert('Purchase Required', 'Purchase the album to play tracks');
      return;
    }

    navigation.navigate('Player', { album, currentTrack: track });
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        {/* Header with Album Art */}
        <View style={styles.headerContainer}>
          <Image source={{ uri: album.coverImageUrl }} style={styles.albumArt} />
          <LinearGradient
            colors={['transparent', 'rgba(0,0,0,0.7)']}
            style={styles.gradient}
          />
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => navigation.goBack()}
          >
            <Ionicons name="arrow-back" size={24} color={colors.white} />
          </TouchableOpacity>
          {isPurchased && (
            <View style={styles.purchasedBadge}>
              <Ionicons name="checkmark-circle" size={20} color={colors.white} />
            </View>
          )}
        </View>

        {/* Album Info */}
        <View style={styles.albumInfo}>
          <View style={styles.albumHeader}>
            <View style={styles.albumTitleContainer}>
              <Text style={styles.albumTitle}>{album.title}</Text>
              <Text style={styles.artistName}>{album.artistName}</Text>
            </View>
            {isPurchased && (
              <View style={styles.ownedIcon}>
                <Ionicons name="checkmark-circle" size={20} color={colors.primary} />
              </View>
            )}
          </View>

          <View style={styles.albumMeta}>
            <View style={styles.genreTag}>
              <Text style={styles.genreText}>{album.genre}</Text>
            </View>
            <View style={styles.metaItem}>
              <Ionicons name="musical-notes" size={16} color={colors.textSecondary} />
              <Text style={styles.metaText}>{album.tracks?.length || 0} tracks</Text>
            </View>
          </View>

          {album.description && (
            <Text style={styles.description}>{album.description}</Text>
          )}

          {/* Purchase Button */}
          {!isPurchased && (
            <TouchableOpacity style={styles.purchaseButton} onPress={purchaseAlbum}>
              <Ionicons name="cart" size={20} color={colors.white} />
              <Text style={styles.purchaseButtonText}>
                Purchase for ${album.price}
              </Text>
            </TouchableOpacity>
          )}

          {/* Track List */}
          <View style={styles.trackListContainer}>
            <Text style={styles.trackListTitle}>Track List</Text>
            {album.tracks && album.tracks.length > 0 ? (
              album.tracks.map((track, index) => (
                <TouchableOpacity
                  key={track.id || index}
                  style={styles.trackItem}
                  onPress={() => playTrack(track)}
                >
                  <View style={styles.trackLeft}>
                    <View
                      style={[
                        styles.playButton,
                        { backgroundColor: isPurchased ? colors.primary : colors.border },
                      ]}
                    >
                      <Ionicons
                        name={isPurchased ? 'play' : 'lock-closed'}
                        size={16}
                        color={isPurchased ? colors.white : colors.textSecondary}
                      />
                    </View>
                    <View style={styles.trackInfo}>
                      <Text
                        style={[
                          styles.trackTitle,
                          { color: isPurchased ? colors.text : colors.textSecondary },
                        ]}
                      >
                        {track.title}
                      </Text>
                      <Text style={styles.trackNumber}>Track {track.trackNumber}</Text>
                    </View>
                  </View>
                  <Text style={styles.trackDuration}>{track.duration}</Text>
                </TouchableOpacity>
              ))
            ) : (
              <Text style={styles.noTracksText}>No tracks available</Text>
            )}
          </View>
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
  headerContainer: {
    height: 300,
    position: 'relative',
  },
  albumArt: {
    width: '100%',
    height: '100%',
  },
  gradient: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 100,
  },
  backButton: {
    position: 'absolute',
    top: 50,
    left: 20,
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  purchasedBadge: {
    position: 'absolute',
    top: 50,
    right: 20,
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  albumInfo: {
    padding: 20,
  },
  albumHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 12,
  },
  albumTitleContainer: {
    flex: 1,
  },
  albumTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 4,
  },
  artistName: {
    fontSize: 18,
    color: colors.secondary,
    fontWeight: '600',
  },
  ownedIcon: {
    marginLeft: 16,
  },
  albumMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  genreTag: {
    backgroundColor: colors.tertiary,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
    marginRight: 12,
  },
  genreText: {
    color: colors.white,
    fontSize: 12,
    fontWeight: '600',
  },
  metaItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metaText: {
    marginLeft: 4,
    fontSize: 14,
    color: colors.textSecondary,
  },
  description: {
    fontSize: 16,
    color: colors.textSecondary,
    lineHeight: 24,
    marginBottom: 24,
  },
  purchaseButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    paddingVertical: 16,
    borderRadius: 12,
    marginBottom: 24,
  },
  purchaseButtonText: {
    color: colors.white,
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  trackListContainer: {
    marginTop: 8,
  },
  trackListTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  trackItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 12,
    paddingHorizontal: 16,
    backgroundColor: colors.surface,
    borderRadius: 12,
    marginBottom: 8,
  },
  trackLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  playButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  trackInfo: {
    flex: 1,
  },
  trackTitle: {
    fontSize: 16,
    fontWeight: '500',
  },
  trackNumber: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  trackDuration: {
    fontSize: 14,
    color: colors.textSecondary,
  },
  noTracksText: {
    textAlign: 'center',
    color: colors.textSecondary,
    fontSize: 16,
    marginTop: 20,
  },
});