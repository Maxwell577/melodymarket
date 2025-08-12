import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  RefreshControl,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../theme/theme';

export default function ArtistDashboardScreen({ navigation }) {
  const [isLoading, setIsLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  
  // Mock data
  const artistBalance = 234.50;
  const analytics = {
    totalStreams: 15672,
    totalFollowers: 1247,
    totalEarnings: 234.50,
    activeTrackss: 3,
    monthlyStreams: {
      'Jan': 1200,
      'Feb': 1800,
      'Mar': 2100,
      'Apr': 1900,
      'May': 2400,
      'Jun': 2800,
    },
    topTracks: [
      { id: '1', title: 'Neon Dreams', streams: 5420, earnings: 89.00 },
      { id: '2', title: 'City Lights', streams: 3890, earnings: 67.00 },
      { id: '3', title: 'Digital Rain', streams: 2340, earnings: 45.00 },
    ],
  };

  const onRefresh = async () => {
    setRefreshing(true);
    // Simulate loading
    setTimeout(() => setRefreshing(false), 1000);
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

  const ActionCard = ({ title, subtitle, icon, onPress }) => (
    <TouchableOpacity style={styles.actionCard} onPress={onPress}>
      <Ionicons name={icon} size={32} color={colors.primary} />
      <Text style={styles.actionTitle}>{title}</Text>
      <Text style={styles.actionSubtitle}>{subtitle}</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {/* Header */}
        <View style={styles.header}>
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => navigation.goBack()}
          >
            <Ionicons name="arrow-back" size={24} color={colors.text} />
          </TouchableOpacity>
          <Text style={styles.headerTitle}>Artist Dashboard</Text>
          <TouchableOpacity
            style={styles.uploadButton}
            onPress={() => navigation.navigate('Upload')}
          >
            <Ionicons name="cloud-upload" size={24} color={colors.white} />
          </TouchableOpacity>
        </View>

        {/* Balance Card */}
        <LinearGradient
          colors={[colors.primary, colors.secondary]}
          style={styles.balanceCard}
        >
          <Text style={styles.balanceLabel}>Available Balance</Text>
          <Text style={styles.balanceAmount}>${artistBalance.toFixed(2)}</Text>
          <TouchableOpacity
            style={styles.withdrawButton}
            onPress={() => navigation.navigate('Withdrawal', { balance: artistBalance })}
          >
            <Ionicons name="wallet" size={16} color={colors.primary} />
            <Text style={styles.withdrawButtonText}>Withdraw</Text>
          </TouchableOpacity>
        </LinearGradient>

        {/* Quick Stats */}
        <View style={styles.statsContainer}>
          <View style={styles.statsRow}>
            <StatCard
              title="Total Streams"
              value={analytics.totalStreams.toLocaleString()}
              icon="play-circle-outline"
              color={colors.primary}
            />
            <StatCard
              title="Followers"
              value={analytics.totalFollowers.toLocaleString()}
              icon="people-outline"
              color={colors.success}
            />
          </View>
          <View style={styles.statsRow}>
            <StatCard
              title="Total Earnings"
              value={`$${analytics.totalEarnings.toFixed(2)}`}
              icon="cash-outline"
              color={colors.warning}
            />
            <StatCard
              title="Active Tracks"
              value={analytics.activeTrackss.toString()}
              icon="musical-notes-outline"
              color={colors.tertiary}
            />
          </View>
        </View>

        {/* Monthly Performance Chart */}
        <View style={styles.chartContainer}>
          <Text style={styles.chartTitle}>Monthly Streams</Text>
          <View style={styles.chart}>
            {Object.entries(analytics.monthlyStreams).map(([month, streams]) => {
              const maxStreams = Math.max(...Object.values(analytics.monthlyStreams));
              const height = (streams / maxStreams) * 120;
              
              return (
                <View key={month} style={styles.chartBar}>
                  <Text style={styles.chartValue}>{streams}</Text>
                  <View
                    style={[
                      styles.chartBarFill,
                      { height, backgroundColor: colors.primary },
                    ]}
                  />
                  <Text style={styles.chartLabel}>{month}</Text>
                </View>
              );
            })}
          </View>
        </View>

        {/* Top Performing Tracks */}
        <View style={styles.topTracksContainer}>
          <Text style={styles.sectionTitle}>Top Performing Tracks</Text>
          {analytics.topTracks.map((track, index) => (
            <View key={track.id} style={styles.trackItem}>
              <View style={styles.trackLeft}>
                <View style={styles.trackIcon}>
                  <Ionicons name="musical-note" size={20} color={colors.primary} />
                </View>
                <View style={styles.trackInfo}>
                  <Text style={styles.trackTitle}>{track.title}</Text>
                  <Text style={styles.trackStats}>
                    {track.streams.toLocaleString()} streams
                  </Text>
                </View>
              </View>
              <View style={styles.trackRight}>
                <Text style={styles.trackEarnings}>${track.earnings.toFixed(2)}</Text>
                <Ionicons name="trending-up" size={16} color={colors.success} />
              </View>
            </View>
          ))}
        </View>

        {/* Quick Actions */}
        <View style={styles.actionsContainer}>
          <Text style={styles.sectionTitle}>Quick Actions</Text>
          <View style={styles.actionsGrid}>
            <ActionCard
              title="Upload Track"
              subtitle="Add new music"
              icon="cloud-upload"
              onPress={() => navigation.navigate('Upload')}
            />
            <ActionCard
              title="View Analytics"
              subtitle="Detailed insights"
              icon="analytics"
              onPress={() => {}}
            />
            <ActionCard
              title="Promote Track"
              subtitle="Boost visibility"
              icon="megaphone"
              onPress={() => {}}
            />
            <ActionCard
              title="Edit Profile"
              subtitle="Update info"
              icon="person-circle"
              onPress={() => {}}
            />
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
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingVertical: 16,
  },
  backButton: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: colors.text,
  },
  uploadButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  balanceCard: {
    marginHorizontal: 20,
    padding: 20,
    borderRadius: 16,
    marginBottom: 24,
  },
  balanceLabel: {
    color: 'rgba(255, 255, 255, 0.9)',
    fontSize: 16,
    marginBottom: 8,
  },
  balanceAmount: {
    color: colors.white,
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  withdrawButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.white,
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
    alignSelf: 'flex-start',
  },
  withdrawButtonText: {
    color: colors.primary,
    marginLeft: 4,
    fontWeight: '600',
  },
  statsContainer: {
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  statsRow: {
    flexDirection: 'row',
    gap: 16,
    marginBottom: 16,
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
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 4,
  },
  statTitle: {
    fontSize: 12,
    color: colors.textSecondary,
    textAlign: 'center',
  },
  chartContainer: {
    backgroundColor: colors.white,
    marginHorizontal: 20,
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  chartTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  chart: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'flex-end',
    height: 160,
  },
  chartBar: {
    alignItems: 'center',
    flex: 1,
  },
  chartValue: {
    fontSize: 10,
    color: colors.textSecondary,
    marginBottom: 4,
  },
  chartBarFill: {
    width: 20,
    borderRadius: 4,
    marginBottom: 8,
  },
  chartLabel: {
    fontSize: 10,
    color: colors.textSecondary,
  },
  topTracksContainer: {
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  trackItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.white,
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  trackLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  trackIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: colors.primary + '20',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  trackInfo: {
    flex: 1,
  },
  trackTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.text,
  },
  trackStats: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  trackRight: {
    alignItems: 'flex-end',
  },
  trackEarnings: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 2,
  },
  actionsContainer: {
    paddingHorizontal: 20,
    paddingBottom: 40,
  },
  actionsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 16,
  },
  actionCard: {
    width: '47%',
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
  actionTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    color: colors.text,
    marginTop: 12,
    textAlign: 'center',
  },
  actionSubtitle: {
    fontSize: 12,
    color: colors.textSecondary,
    marginTop: 4,
    textAlign: 'center',
  },
});