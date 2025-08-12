import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  FlatList,
  Image,
  RefreshControl,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../theme/theme';
import { StorageService } from '../services/StorageService';

export default function HomeScreen({ navigation }) {
  const [albums, setAlbums] = useState([]);
  const [selectedGenre, setSelectedGenre] = useState('All');
  const [isLoading, setIsLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const genres = ['All', 'Electronic', 'Acoustic', 'EDM', 'Jazz', 'Rock', 'Pop'];

  useEffect(() => {
    loadAlbums();
  }, []);

  const loadAlbums = async () => {
    try {
      const albumsData = await StorageService.getAlbums();
      setAlbums(albumsData);
    } catch (error) {
      console.error('Error loading albums:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const onRefresh = async () => {
    setRefreshing(true);
    await loadAlbums();
    setRefreshing(false);
  };

  const filteredAlbums = selectedGenre === 'All' 
    ? albums 
    : albums.filter(album => album.genre === selectedGenre);

  const renderAlbumCard = ({ item }) => (
    <TouchableOpacity
      style={styles.albumCard}
      onPress={() => navigation.navigate('AlbumDetail', { album: item })}
    >
      <Image source={{ uri: item.coverImageUrl }} style={styles.albumImage} />
      <View style={styles.albumInfo}>
        <Text style={styles.albumTitle} numberOfLines={1}>
          {item.title}
        </Text>
        <Text style={styles.albumArtist} numberOfLines={1}>
          {item.artistName}
        </Text>
        <View style={styles.albumMeta}>
          <View style={styles.genreTag}>
            <Text style={styles.genreText}>{item.genre}</Text>
          </View>
          <Text style={styles.albumPrice}>${item.price}</Text>
        </View>
      </View>
    </TouchableOpacity>
  );

  const renderGenreChip = (genre) => (
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
  );

  if (isLoading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text>Loading amazing music...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.headerTitle}>Discover Music 🎵</Text>
            <Text style={styles.headerSubtitle}>
              {filteredAlbums.length} albums available
            </Text>
          </View>
          <View style={styles.headerActions}>
            <TouchableOpacity style={styles.headerButton}>
              <Ionicons name="search" size={24} color={colors.text} />
            </TouchableOpacity>
            <TouchableOpacity style={styles.headerButton}>
              <Ionicons name="notifications-outline" size={24} color={colors.text} />
            </TouchableOpacity>
          </View>
        </View>

        {/* Featured Album */}
        {filteredAlbums.length > 0 && (
          <TouchableOpacity
            style={styles.featuredContainer}
            onPress={() => navigation.navigate('AlbumDetail', { album: filteredAlbums[0] })}
          >
            <LinearGradient
              colors={[colors.primary, colors.secondary]}
              style={styles.featuredGradient}
            >
              <View style={styles.featuredContent}>
                <View style={styles.featuredText}>
                  <Text style={styles.featuredTitle}>Featured Album</Text>
                  <Text style={styles.featuredAlbumTitle}>
                    {filteredAlbums[0].title}
                  </Text>
                  <Text style={styles.featuredArtist}>
                    by {filteredAlbums[0].artistName}
                  </Text>
                  <TouchableOpacity style={styles.listenButton}>
                    <Text style={styles.listenButtonText}>Listen Now</Text>
                  </TouchableOpacity>
                </View>
                <Image
                  source={{ uri: filteredAlbums[0].coverImageUrl }}
                  style={styles.featuredImage}
                />
              </View>
            </LinearGradient>
          </TouchableOpacity>
        )}

        {/* Genre Filter */}
        <View style={styles.genreSection}>
          <Text style={styles.sectionTitle}>Genres</Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={styles.genreScroll}
          >
            {genres.map(renderGenreChip)}
          </ScrollView>
        </View>

        {/* Albums Grid */}
        <View style={styles.albumsSection}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>All Albums</Text>
            <TouchableOpacity>
              <Text style={styles.viewAllText}>View All</Text>
            </TouchableOpacity>
          </View>
          
          <FlatList
            data={filteredAlbums}
            renderItem={renderAlbumCard}
            keyExtractor={(item) => item.id}
            numColumns={2}
            scrollEnabled={false}
            columnWrapperStyle={styles.albumRow}
            contentContainerStyle={styles.albumGrid}
          />
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
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
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
  headerActions: {
    flexDirection: 'row',
  },
  headerButton: {
    marginLeft: 16,
  },
  featuredContainer: {
    marginHorizontal: 20,
    marginBottom: 24,
    borderRadius: 16,
    overflow: 'hidden',
  },
  featuredGradient: {
    padding: 20,
  },
  featuredContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  featuredText: {
    flex: 1,
  },
  featuredTitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.9)',
    marginBottom: 8,
  },
  featuredAlbumTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: colors.white,
    marginBottom: 4,
  },
  featuredArtist: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.9)',
    marginBottom: 16,
  },
  listenButton: {
    backgroundColor: colors.white,
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 20,
    alignSelf: 'flex-start',
  },
  listenButtonText: {
    color: colors.primary,
    fontWeight: '600',
  },
  featuredImage: {
    width: 120,
    height: 120,
    borderRadius: 12,
    marginLeft: 16,
  },
  genreSection: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginHorizontal: 20,
    marginBottom: 12,
  },
  genreScroll: {
    paddingLeft: 20,
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
  albumsSection: {
    paddingHorizontal: 20,
    paddingBottom: 20,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  viewAllText: {
    color: colors.primary,
    fontWeight: '600',
  },
  albumGrid: {
    paddingBottom: 20,
  },
  albumRow: {
    justifyContent: 'space-between',
  },
  albumCard: {
    flex: 1,
    backgroundColor: colors.white,
    borderRadius: 12,
    marginBottom: 16,
    marginHorizontal: 4,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  albumImage: {
    width: '100%',
    height: 140,
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
  },
  albumInfo: {
    padding: 12,
  },
  albumTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 4,
  },
  albumArtist: {
    fontSize: 14,
    color: colors.textSecondary,
    marginBottom: 8,
  },
  albumMeta: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  genreTag: {
    backgroundColor: colors.accent,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  genreText: {
    color: colors.white,
    fontSize: 10,
    fontWeight: '600',
  },
  albumPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.primary,
  },
});