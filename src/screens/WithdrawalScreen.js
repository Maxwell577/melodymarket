import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../theme/theme';

export default function WithdrawalScreen({ route, navigation }) {
  const { balance = 0 } = route.params || {};
  const [amount, setAmount] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);

  // Mock withdrawal history
  const withdrawalHistory = [
    {
      id: '1',
      amount: 50.00,
      phoneNumber: '+256700000000',
      status: 'completed',
      date: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
    },
    {
      id: '2',
      amount: 25.00,
      phoneNumber: '+256700000000',
      status: 'processing',
      date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
    },
  ];

  const processWithdrawal = async () => {
    if (!amount || !phoneNumber) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    const withdrawalAmount = parseFloat(amount);
    if (withdrawalAmount <= 0) {
      Alert.alert('Error', 'Amount must be greater than 0');
      return;
    }

    if (withdrawalAmount > balance) {
      Alert.alert('Error', 'Insufficient balance');
      return;
    }

    if (withdrawalAmount < 10) {
      Alert.alert('Error', 'Minimum withdrawal is $10');
      return;
    }

    if (!phoneNumber.startsWith('+256') || phoneNumber.length !== 13) {
      Alert.alert('Error', 'Please enter a valid Ugandan phone number');
      return;
    }

    setIsProcessing(true);

    // Simulate processing
    setTimeout(() => {
      setIsProcessing(false);
      Alert.alert(
        'Success',
        'Withdrawal request submitted successfully! Funds will be sent to your MTN Mobile Money account within 1-3 business days.',
        [
          {
            text: 'OK',
            onPress: () => {
              setAmount('');
              setPhoneNumber('');
            },
          },
        ]
      );
    }, 2000);
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'completed':
        return colors.success;
      case 'processing':
        return colors.warning;
      case 'failed':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'completed':
        return 'checkmark-circle';
      case 'processing':
        return 'time';
      case 'failed':
        return 'close-circle';
      default:
        return 'help-circle';
    }
  };

  const formatDate = (date) => {
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        {/* Header */}
        <View style={styles.header}>
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => navigation.goBack()}
          >
            <Ionicons name="arrow-back" size={24} color={colors.text} />
          </TouchableOpacity>
          <Text style={styles.headerTitle}>Withdraw Funds</Text>
          <View style={styles.placeholder} />
        </View>

        {/* Available Balance */}
        <LinearGradient
          colors={[colors.primary, colors.secondary]}
          style={styles.balanceCard}
        >
          <View style={styles.balanceHeader}>
            <Ionicons name="wallet" size={24} color={colors.white} />
            <Text style={styles.balanceLabel}>Available Balance</Text>
          </View>
          <Text style={styles.balanceAmount}>${balance.toFixed(2)}</Text>
        </LinearGradient>

        {/* Withdrawal Form */}
        <View style={styles.formContainer}>
          <Text style={styles.formTitle}>Request Withdrawal</Text>

          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>Amount to Withdraw (USD)</Text>
            <TextInput
              style={styles.textInput}
              placeholder="Enter amount"
              value={amount}
              onChangeText={setAmount}
              keyboardType="numeric"
            />
          </View>

          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>MTN Mobile Money Number</Text>
            <TextInput
              style={styles.textInput}
              placeholder="+256XXXXXXXXX"
              value={phoneNumber}
              onChangeText={setPhoneNumber}
              keyboardType="phone-pad"
            />
          </View>

          {/* Important Notes */}
          <View style={styles.notesContainer}>
            <View style={styles.notesHeader}>
              <Ionicons name="information-circle" size={16} color={colors.warning} />
              <Text style={styles.notesTitle}>Important Notes</Text>
            </View>
            <Text style={styles.notesText}>
              • Minimum withdrawal: $10{'\n'}
              • Processing time: 1-3 business days{'\n'}
              • Transaction fee: 2% of withdrawal amount{'\n'}
              • Funds will be sent to your MTN Mobile Money
            </Text>
          </View>

          <TouchableOpacity
            style={[styles.withdrawButton, isProcessing && styles.withdrawButtonDisabled]}
            onPress={processWithdrawal}
            disabled={isProcessing}
          >
            {isProcessing ? (
              <View style={styles.processingContainer}>
                <Text style={styles.withdrawButtonText}>Processing...</Text>
              </View>
            ) : (
              <Text style={styles.withdrawButtonText}>Request Withdrawal</Text>
            )}
          </TouchableOpacity>
        </View>

        {/* Withdrawal History */}
        <View style={styles.historyContainer}>
          <Text style={styles.historyTitle}>Withdrawal History</Text>
          
          {withdrawalHistory.length === 0 ? (
            <View style={styles.emptyHistory}>
              <Ionicons name="time" size={48} color={colors.textSecondary} />
              <Text style={styles.emptyHistoryTitle}>No withdrawal history</Text>
            </View>
          ) : (
            withdrawalHistory.map((withdrawal) => (
              <View key={withdrawal.id} style={styles.historyItem}>
                <View style={styles.historyLeft}>
                  <View
                    style={[
                      styles.historyIcon,
                      { backgroundColor: getStatusColor(withdrawal.status) + '20' },
                    ]}
                  >
                    <Ionicons
                      name={getStatusIcon(withdrawal.status)}
                      size={24}
                      color={getStatusColor(withdrawal.status)}
                    />
                  </View>
                  <View style={styles.historyInfo}>
                    <Text style={styles.historyAmount}>
                      ${withdrawal.amount.toFixed(2)}
                    </Text>
                    <Text style={styles.historyPhone}>
                      To: {withdrawal.phoneNumber}
                    </Text>
                    <Text style={styles.historyDate}>
                      {formatDate(withdrawal.date)}
                    </Text>
                  </View>
                </View>
                <View
                  style={[
                    styles.statusBadge,
                    { backgroundColor: getStatusColor(withdrawal.status) + '20' },
                  ]}
                >
                  <Text
                    style={[
                      styles.statusText,
                      { color: getStatusColor(withdrawal.status) },
                    ]}
                  >
                    {withdrawal.status.charAt(0).toUpperCase() + withdrawal.status.slice(1)}
                  </Text>
                </View>
              </View>
            ))
          )}
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
  placeholder: {
    width: 40,
  },
  balanceCard: {
    marginHorizontal: 20,
    padding: 20,
    borderRadius: 16,
    marginBottom: 24,
  },
  balanceHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  balanceLabel: {
    color: 'rgba(255, 255, 255, 0.9)',
    fontSize: 16,
    marginLeft: 8,
  },
  balanceAmount: {
    color: colors.white,
    fontSize: 32,
    fontWeight: 'bold',
  },
  formContainer: {
    backgroundColor: colors.white,
    marginHorizontal: 20,
    padding: 20,
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
  formTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  inputContainer: {
    marginBottom: 16,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 8,
  },
  textInput: {
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 8,
    paddingHorizontal: 16,
    paddingVertical: 12,
    fontSize: 16,
  },
  notesContainer: {
    backgroundColor: colors.warning + '10',
    padding: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: colors.warning + '30',
    marginBottom: 20,
  },
  notesHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  notesTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    color: colors.warning,
    marginLeft: 8,
  },
  notesText: {
    fontSize: 12,
    color: colors.warning,
    lineHeight: 18,
  },
  withdrawButton: {
    backgroundColor: colors.primary,
    paddingVertical: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  withdrawButtonDisabled: {
    opacity: 0.6,
  },
  withdrawButtonText: {
    color: colors.white,
    fontSize: 16,
    fontWeight: 'bold',
  },
  processingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  historyContainer: {
    paddingHorizontal: 20,
    paddingBottom: 40,
  },
  historyTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 16,
  },
  emptyHistory: {
    alignItems: 'center',
    paddingVertical: 40,
    backgroundColor: colors.surface,
    borderRadius: 12,
  },
  emptyHistoryTitle: {
    fontSize: 16,
    color: colors.textSecondary,
    marginTop: 12,
  },
  historyItem: {
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
  historyLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  historyIcon: {
    width: 50,
    height: 50,
    borderRadius: 25,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  historyInfo: {
    flex: 1,
  },
  historyAmount: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.text,
  },
  historyPhone: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 2,
  },
  historyDate: {
    fontSize: 12,
    color: colors.textSecondary,
    marginTop: 2,
  },
  statusBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
  },
  statusText: {
    fontSize: 12,
    fontWeight: 'bold',
  },
});