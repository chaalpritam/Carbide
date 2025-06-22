/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { StatusBar, StyleSheet, useColorScheme, View, Text, Image, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

// Photos Screen Component
const PhotosScreen = () => {
  const photos = [
    { id: 1, uri: 'https://picsum.photos/300/300?random=1', date: 'Today' },
    { id: 2, uri: 'https://picsum.photos/300/300?random=2', date: 'Today' },
    { id: 3, uri: 'https://picsum.photos/300/300?random=3', date: 'Today' },
    { id: 4, uri: 'https://picsum.photos/300/300?random=4', date: 'Today' },
    { id: 5, uri: 'https://picsum.photos/300/300?random=5', date: 'Yesterday' },
    { id: 6, uri: 'https://picsum.photos/300/300?random=6', date: 'Yesterday' },
    { id: 7, uri: 'https://picsum.photos/300/300?random=7', date: 'Yesterday' },
    { id: 8, uri: 'https://picsum.photos/300/300?random=8', date: 'Yesterday' },
    { id: 9, uri: 'https://picsum.photos/300/300?random=9', date: 'Last week' },
    { id: 10, uri: 'https://picsum.photos/300/300?random=10', date: 'Last week' },
    { id: 11, uri: 'https://picsum.photos/300/300?random=11', date: 'Last week' },
    { id: 12, uri: 'https://picsum.photos/300/300?random=12', date: 'Last week' },
  ];

  const groupedPhotos = photos.reduce((acc, photo) => {
    if (!acc[photo.date]) {
      acc[photo.date] = [];
    }
    acc[photo.date].push(photo);
    return acc;
  }, {});

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Photos</Text>
        <TouchableOpacity style={styles.searchButton}>
          <Icon name="search" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>
      
      <ScrollView style={styles.scrollView}>
        {Object.entries(groupedPhotos).map(([date, photosGroup]) => (
          <View key={date} style={styles.dateSection}>
            <Text style={styles.dateText}>{date}</Text>
            <View style={styles.photosGrid}>
              {photosGroup.map((photo) => (
                <TouchableOpacity key={photo.id} style={styles.photoContainer}>
                  <Image source={{ uri: photo.uri }} style={styles.photo} />
                </TouchableOpacity>
              ))}
            </View>
          </View>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
};

// For You Screen Component
const ForYouScreen = () => {
  const memories = [
    { id: 1, title: '1 year ago', subtitle: '3 photos', uri: 'https://picsum.photos/300/300?random=13' },
    { id: 2, title: '2 years ago', subtitle: '5 photos', uri: 'https://picsum.photos/300/300?random=14' },
    { id: 3, title: '3 years ago', subtitle: '2 photos', uri: 'https://picsum.photos/300/300?random=15' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>For you</Text>
      </View>
      
      <ScrollView style={styles.scrollView}>
        <View style={styles.memoriesSection}>
          <Text style={styles.sectionTitle}>Memories</Text>
          {memories.map((memory) => (
            <TouchableOpacity key={memory.id} style={styles.memoryCard}>
              <Image source={{ uri: memory.uri }} style={styles.memoryImage} />
              <View style={styles.memoryOverlay}>
                <Text style={styles.memoryTitle}>{memory.title}</Text>
                <Text style={styles.memorySubtitle}>{memory.subtitle}</Text>
              </View>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Albums Screen Component
const AlbumsScreen = () => {
  const albums = [
    { id: 1, title: 'Recents', count: '1,234', uri: 'https://picsum.photos/300/300?random=16' },
    { id: 2, title: 'Favorites', count: '56', uri: 'https://picsum.photos/300/300?random=17' },
    { id: 3, title: 'Screenshots', count: '89', uri: 'https://picsum.photos/300/300?random=18' },
    { id: 4, title: 'Camera', count: '234', uri: 'https://picsum.photos/300/300?random=19' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Albums</Text>
      </View>
      
      <ScrollView style={styles.scrollView}>
        <View style={styles.albumsGrid}>
          {albums.map((album) => (
            <TouchableOpacity key={album.id} style={styles.albumContainer}>
              <Image source={{ uri: album.uri }} style={styles.albumImage} />
              <View style={styles.albumInfo}>
                <Text style={styles.albumTitle}>{album.title}</Text>
                <Text style={styles.albumCount}>{album.count} photos</Text>
              </View>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Search Screen Component
const SearchScreen = () => {
  const categories = [
    { id: 1, title: 'People', icon: 'person', color: '#FF6B6B' },
    { id: 2, title: 'Places', icon: 'place', color: '#4ECDC4' },
    { id: 3, title: 'Things', icon: 'category', color: '#45B7D1' },
    { id: 4, title: 'Videos', icon: 'videocam', color: '#96CEB4' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Search</Text>
      </View>
      
      <ScrollView style={styles.scrollView}>
        <View style={styles.searchCategories}>
          {categories.map((category) => (
            <TouchableOpacity key={category.id} style={styles.categoryCard}>
              <View style={[styles.categoryIcon, { backgroundColor: category.color }]}>
                <Icon name={category.icon} size={24} color="white" />
              </View>
              <Text style={styles.categoryTitle}>{category.title}</Text>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Library Screen Component
const LibraryScreen = () => {
  const libraryItems = [
    { id: 1, title: 'Recently Deleted', icon: 'delete', count: '0 items' },
    { id: 2, title: 'Hidden', icon: 'visibility-off', count: '0 items' },
    { id: 3, title: 'Imports', icon: 'file-download', count: '0 items' },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Library</Text>
      </View>
      
      <ScrollView style={styles.scrollView}>
        <View style={styles.libraryList}>
          {libraryItems.map((item) => (
            <TouchableOpacity key={item.id} style={styles.libraryItem}>
              <Icon name={item.icon} size={24} color="#007AFF" />
              <View style={styles.libraryItemInfo}>
                <Text style={styles.libraryItemTitle}>{item.title}</Text>
                <Text style={styles.libraryItemCount}>{item.count}</Text>
              </View>
              <Icon name="chevron-right" size={24} color="#C7C7CC" />
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Tab Navigator
const TabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;

          if (route.name === 'Photos') {
            iconName = 'photo-library';
          } else if (route.name === 'For You') {
            iconName = 'favorite';
          } else if (route.name === 'Albums') {
            iconName = 'photo-album';
          } else if (route.name === 'Search') {
            iconName = 'search';
          } else if (route.name === 'Library') {
            iconName = 'folder';
          }

          return <Icon name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#007AFF',
        tabBarInactiveTintColor: '#8E8E93',
        tabBarStyle: {
          backgroundColor: '#FFFFFF',
          borderTopColor: '#C7C7CC',
          borderTopWidth: 0.5,
          paddingBottom: 5,
          paddingTop: 5,
          height: 85,
        },
        headerShown: false,
      })}
    >
      <Tab.Screen name="Photos" component={PhotosScreen} />
      <Tab.Screen name="For You" component={ForYouScreen} />
      <Tab.Screen name="Albums" component={AlbumsScreen} />
      <Tab.Screen name="Search" component={SearchScreen} />
      <Tab.Screen name="Library" component={LibraryScreen} />
    </Tab.Navigator>
  );
};

function App() {
  const isDarkMode = useColorScheme() === 'dark';

  return (
    <NavigationContainer>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} backgroundColor="#FFFFFF" />
      <TabNavigator />
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  headerTitle: {
    fontSize: 34,
    fontWeight: '700',
    color: '#000000',
  },
  searchButton: {
    padding: 8,
  },
  scrollView: {
    flex: 1,
  },
  dateSection: {
    marginBottom: 20,
  },
  dateText: {
    fontSize: 22,
    fontWeight: '600',
    color: '#000000',
    marginHorizontal: 16,
    marginVertical: 8,
  },
  photosGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
  },
  photoContainer: {
    width: '33.33%',
    aspectRatio: 1,
    padding: 1,
  },
  photo: {
    flex: 1,
    borderRadius: 8,
  },
  memoriesSection: {
    paddingHorizontal: 16,
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '600',
    color: '#000000',
    marginVertical: 16,
  },
  memoryCard: {
    height: 200,
    borderRadius: 12,
    marginBottom: 16,
    overflow: 'hidden',
  },
  memoryImage: {
    width: '100%',
    height: '100%',
  },
  memoryOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    padding: 16,
  },
  memoryTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  memorySubtitle: {
    fontSize: 14,
    color: '#FFFFFF',
    opacity: 0.8,
  },
  albumsGrid: {
    paddingHorizontal: 16,
  },
  albumContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  albumImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    marginRight: 16,
  },
  albumInfo: {
    flex: 1,
  },
  albumTitle: {
    fontSize: 17,
    fontWeight: '500',
    color: '#000000',
  },
  albumCount: {
    fontSize: 15,
    color: '#8E8E93',
    marginTop: 2,
  },
  searchCategories: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    justifyContent: 'space-between',
  },
  categoryCard: {
    width: '48%',
    backgroundColor: '#F2F2F7',
    borderRadius: 12,
    padding: 20,
    alignItems: 'center',
    marginBottom: 16,
  },
  categoryIcon: {
    width: 50,
    height: 50,
    borderRadius: 25,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  categoryTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: '#000000',
  },
  libraryList: {
    paddingHorizontal: 16,
  },
  libraryItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 16,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  libraryItemInfo: {
    flex: 1,
    marginLeft: 16,
  },
  libraryItemTitle: {
    fontSize: 17,
    fontWeight: '500',
    color: '#000000',
  },
  libraryItemCount: {
    fontSize: 15,
    color: '#8E8E93',
    marginTop: 2,
  },
});

export default App;
