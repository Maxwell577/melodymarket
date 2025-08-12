import AsyncStorage from '@react-native-async-storage/async-storage';

export class StorageService {
  static async init() {
    try {
      const isInitialized = await AsyncStorage.getItem('isInitialized');
      if (!isInitialized) {
        await this.createSampleData();
        await AsyncStorage.setItem('isInitialized', 'true');
      }
    } catch (error) {
      console.error('Error initializing storage:', error);
    }
  }

  static async createSampleData() {
    const sampleAlbums = [
      {
        id: '1',
        title: 'Midnight Vibes',
        artistId: 'artist1',
        artistName: 'Luna Eclipse',
        price: 12.99,
        coverImageUrl: 'https://picsum.photos/300/300?random=1',
        createdAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
        genre: 'Electronic',
        description: 'A collection of ambient electronic tracks perfect for late-night listening.',
        tracks: [
          {
            id: '1-1',
            title: 'Neon Dreams',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '4:32',
            albumId: '1',
            trackNumber: 1,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
          },
          {
            id: '1-2',
            title: 'City Lights',
            artist: 'Luna Eclipse',
            artistId: 'artist1',
            duration: '3:47',
            albumId: '1',
            trackNumber: 2,
            price: 2.50,
            isFree: false,
            genre: 'Electronic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
          },
        ],
      },
      {
        id: '2',
        title: 'Acoustic Soul',
        artistId: 'artist2',
        artistName: 'River Stone',
        price: 9.99,
        coverImageUrl: 'https://picsum.photos/300/300?random=2',
        createdAt: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000).toISOString(),
        genre: 'Acoustic',
        description: 'Heartfelt acoustic melodies that speak to the soul.',
        tracks: [
          {
            id: '2-1',
            title: 'Morning Coffee',
            artist: 'River Stone',
            artistId: 'artist2',
            duration: '3:28',
            albumId: '2',
            trackNumber: 1,
            price: 1.99,
            isFree: false,
            genre: 'Acoustic',
            previewUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-02.wav',
            createdAt: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000).toISOString(),
          },
        ],
      },
      {
        id: '3',
        title: 'Beat Drop',
        artistId: 'artist3',
        artistName: 'DJ Thunder',
        price: 15.99,
        coverImageUrl: 'https://picsum.photos/300/300?random=3',
        createdAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
        genre: 'EDM',
        description: 'High-energy electronic dance music to get you moving.',
        tracks: [
          {
            id: '3-1',
            title: 'Bass Explosion',
            artist: 'DJ Thunder',
            artistId: 'artist3',
            duration: '5:43',
            albumId: '3',
            trackNumber: 1,
            price: 2.99,
            isFree: false,
            genre: 'EDM',
            previewUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
            createdAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
          },
        ],
      },
    ];

    await AsyncStorage.setItem('albums', JSON.stringify(sampleAlbums));
    
    // Create sample user
    const sampleUser = {
      id: 'user1',
      name: 'Music Lover',
      email: 'user@example.com',
      isArtist: false,
      purchasedAlbums: ['1', '2'],
      downloadedAlbums: ['1'],
      balance: 0,
    };
    
    await AsyncStorage.setItem('currentUser', JSON.stringify(sampleUser));
  }

  static async getAlbums() {
    try {
      const albums = await AsyncStorage.getItem('albums');
      return albums ? JSON.parse(albums) : [];
    } catch (error) {
      console.error('Error getting albums:', error);
      return [];
    }
  }

  static async saveAlbum(album) {
    try {
      const albums = await this.getAlbums();
      const existingIndex = albums.findIndex(a => a.id === album.id);
      
      if (existingIndex >= 0) {
        albums[existingIndex] = album;
      } else {
        albums.push(album);
      }
      
      await AsyncStorage.setItem('albums', JSON.stringify(albums));
    } catch (error) {
      console.error('Error saving album:', error);
    }
  }

  static async getCurrentUser() {
    try {
      const user = await AsyncStorage.getItem('currentUser');
      return user ? JSON.parse(user) : null;
    } catch (error) {
      console.error('Error getting current user:', error);
      return null;
    }
  }

  static async saveUser(user) {
    try {
      await AsyncStorage.setItem('currentUser', JSON.stringify(user));
    } catch (error) {
      console.error('Error saving user:', error);
    }
  }

  static async getUserPurchasedAlbums() {
    try {
      const user = await this.getCurrentUser();
      if (!user || !user.purchasedAlbums.length) return [];

      const allAlbums = await this.getAlbums();
      return allAlbums.filter(album => user.purchasedAlbums.includes(album.id));
    } catch (error) {
      console.error('Error getting purchased albums:', error);
      return [];
    }
  }

  static async purchaseAlbum(albumId) {
    try {
      const user = await this.getCurrentUser();
      if (user && !user.purchasedAlbums.includes(albumId)) {
        user.purchasedAlbums.push(albumId);
        await this.saveUser(user);
      }
    } catch (error) {
      console.error('Error purchasing album:', error);
    }
  }
}