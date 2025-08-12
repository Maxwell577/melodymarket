import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../theme/theme';
import { StorageService } from '../services/StorageService';

export default function ProfileScreen({ navigation }) {
  const [currentUser, setCurrentUser] = useState(null);
  const [purchasedAlbums, setPurchasedAlbums] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadUserData();
  }, []);

  const loadUserData = async () => {
    try {
      const user = await StorageService.getCurrentUser();
      const purchased = await StorageService.getUserPurchasedAlbums();
      setCurrentUser(user);
      setPurchasedAlbums(purchased);
    } catch (error) {
      console.error('Error loading user data:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const toggleArtistMode = async () => {
    if (currentUser) {
      const updatedUser = {
        ...currentUser,
        isArtist: !currentUser.isArtist,
      };
      await StorageService.saveUser(updatedUser);
      setCurrentUser(updatedUser);
      
      Alert.alert(
        'Success',
        updatedUser.isArtist 
          ? 'Artist mode enabled! You can now upload music.'
          : 'Artist mode disabled.'
      );
    }
  };

  const StatCard = ({ title, value, icon, color }) => (
    <View style={styles.statCard}>
      <View style={[styles.statIcon, { backgroundColor: color + '20' }]}>
        <Ionicons name={icon} size={24} color={color} />
      </View>
      <Text style={styles.statValue}>{value}</Text>
      <Text style={styles.statTitle}>{title}</Text>
    </View>
  );

  const QuickActionButton = ({ icon, label, onPress }) => (
    <TouchableOpacity style={styles.quickActionButton} onPress={onPress}>
      <Ionicons name={icon} size={24} color={colors.primary} />
      <Text style={styles.quickActionLabel}>{label}</Text>
    </TouchableOpacity>
  );

  if (isLoading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text>Loading profile...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        {/* Header */}
        <LinearGradient
          colors={[colors.primary, colors.secondary]}
          style={styles.header}
        >
          <View style={styles.profileInfo}>
            <View style={styles.avatar}>
              <Ionicons name="person" size={40} color={colors.white} />
            </View>
            <View style={styles.userInfo}>
              <Text style={styles.userName}>{currentUser?.name || 'User'}</Text>
              <View style={styles.userBadge}>
                <Text style={styles.userBadgeText}>
                  {currentUser?.isArtist ? '🎤 Artist' : '🎵 Music Lover'}
                </Text>
              </View>
            </View>
          </View>
        </LinearGradient>

        {/* Stats */}
        <View style={styles.statsContainer}>
          <StatCard
            title="Purchased"
            value={purchasedAlbums.length.toString()}
            icon="library"
            color={colors.primary}
          />
          <StatCard
            title={currentUser?.isArtist ? 'Uploaded' : 'Downloaded'}
            value="0"
            icon={currentUser?.isArtist ? 'cloud-upload' : 'download'}
            color={colors.secondary}
          />
        </View>

        {/* Artist Quick Actions */}
        {currentUser?.isArtist && (
          <View style={styles.quickActionsContainer}>
            <View style={styles.quickActionsHeader}>
              <Ionicons name="trending-up" size={20} color={colors.primary} />
              <Text style={styles.quickActionsTitle}>Artist Dashboard</Text>
            </View>
            <View style={styles.quickActionsGrid}>
              <QuickActionButton
                icon="cloud-upload"
                label="Upload"
                onPress={() => navigation.navigate('Upload')}
              />
              <QuickActionButton
                icon="analytics"
                label="Analytics"
                onPress={() => navigation.navigate('ArtistDashboard')}
              />
              <QuickActionButton
                icon="wallet"
                label="Earnings"
                onPress={() => navigation.navigate('Withdrawal', { balance: 0 })}
              />
            </View>
          </View>
        )}

        {/* Settings */}
        <View style={styles.settingsContainer}>
          <Text style={styles.sectionTitle}>Settings</Text>
          
          <View style={styles.settingsCard}>
            <TouchableOpacity style={styles.settingItem} onPress={toggleArtistMode}>
              <View style={styles.settingLeft}>
                <Ionicons
                  name={currentUser?.isArtist ? 'mic' : 'person-add'}
                  size={24}
                  color={colors.primary}
                />
                <View style={styles.settingText}>
                  <Text style={styles.settingTitle}>
                    {currentUser?.isArtist ? 'Disable Artist Mode' : 'Enable Artist Mode'}
                  </Text>
                  <Text style={styles.settingSubtitle}>
                    {currentUser?.isArtist 
                      ? 'Switch back to music listener mode'
                      : 'Start uploading and selling your music'
                    }
                  </Text>
                </View>
              </View>
              <Switch
                value={currentUser?.isArtist || false}
                onValueChange={toggleArtistMode}
                trackColor={{ false: colors.border, true: colors.primary }}
                thumbColor={colors.white}
              />
            </TouchableOpacity>

            <View style={styles.settingDivider} />

            <TouchableOpacity style={styles.settingItem}>
              <View style={styles.settingLeft}>
                <Ionicons name="musical-note" size={24} color={colors.secondary} />
                <View style={styles.settingText}>
                  <Text style={styles.settingTitle}>Audio Quality</Text>
                  <Text style={styles.settingSubtitle}>High (320 kbps)</Text>
                </View>
              </View>
              <Ionicons name="chevron-forward" size={20} color={colors.textSecondary} />
            </TouchableOpacity>

            <View style={styles.settingDivider} />

            <TouchableOpacity style={styles.settingItem}>
              <View style={styles.settingLeft}>
                <Ionicons name="download" size={24} color={colors.tertiary} />
                <View style={styles.settingText}>
                  <Text style={styles.settingTitle}>Auto Download</Text>
                  <Text style={styles.settingSubtitle}>Download purchased music automatically</Text>
                </View>
              </View>
              <Switch
                value={true}
                trackColor={{ false: colors.border, true: colors.tertiary }}
                thumbColor={colors.white}
              />
            </TouchableOpacity>

            <View style={styles.settingDivider} />

            <TouchableOpacity style={styles.settingItem}>
              <View style={styles.settingLeft}>
                <Ionicons name="notifications" size={24} color={colors.warning} />
                <View style={styles.settingText}>
                  <Text style={styles.settingTitle}>Notifications</Text>
                  <Text style={styles.settingSubtitle}>New releases and recommendations</Text>
                </View>
              </View>
              <Ionicons name="chevron-forward" size={20} color={colors.textSecondary} />
            </TouchableOpacity>
          </View>
        </View>

        {/* About */}
        <View style={styles.aboutContainer}>
          <View style={styles.aboutCard}>
            <Text style={styles.aboutTitle}>About MelodyMarket</Text>
            <Text style={styles.aboutText}>
              A revolutionary music marketplace where artists can share their music and fans can discover and support their favorite musicians. Built with love for the music community.
            </Text>
            <Text style={styles.versionText}>Version 1.0.0</Text>
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
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  header: {
    paddingHorizontal: 20,
    paddingVertical: 30,
  },
  profileInfo: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: colors.white,
    marginBottom: 8,
  },
  userBadge: {
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
    alignSelf: 'flex-start',
  },
  userBadgeText: {
    color: colors.white,
    fontSize: 14,
    fontWeight: '600',
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    paddingVertical: 20,
    gap: 16,
  },
  statCard: {
    flex: 1,
    backgroundColor: colors.white,
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  statIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  statValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 4,
  },
  statTitle: {
    fontSize: 12,
    color: colors.textSecondary,
  },
  quickActionsContainer: {
    marginHorizontal: 20,
    marginBottom: 24,
    padding: 16,
    backgroundColor: colors.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: colors.primary + '20',
  },
  quickActionsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  quickActionsTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.primary,
    marginLeft: 8,
  },
  quickActionsGrid: {
    flexDirection: 'row',
    gap: 12,
  },
  quickActionButton: {
    flex: 1,
    alignItems: 'center',
    padding: 12,
    backgroundColor: colors.white,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.border,
  },
  quickActionLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: colors.text,
    marginTop: 4,
    textAlign: 'center',
  },
  settingsContainer: {
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  settingsCard: {
    backgroundColor: colors.white,
    borderRadius: 12,
    overflow: 'hidden',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  settingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  settingLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  settingText: {
    marginLeft: 12,
    flex: 1,
  },
  settingTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
  },
  settingSubtitle: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  settingDivider: {
    height: 1,
    backgroundColor: colors.border,
    marginLeft: 52,
  },
  aboutContainer: {
    paddingHorizontal: 20,
    paddingBottom: 40,
  },
  aboutCard: {
    backgroundColor: colors.white,
    padding: 20,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  aboutTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 8,
  },
  aboutText: {
    fontSize: 14,
    color: colors.textSecondary,
    lineHeight: 20,
    marginBottom: 12,
  },
  versionText: {
    fontSize: 12,
    color: colors.textSecondary,
  },
});