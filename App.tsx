/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useEffect, useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { StatusBar, StyleSheet, useColorScheme, View, Text, Image, ScrollView, TouchableOpacity, SafeAreaView, Dimensions, Alert, PermissionsAndroid, Platform } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { check, request, PERMISSIONS, RESULTS } from 'react-native-permissions';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();
const { width } = Dimensions.get('window');

// Permission Request Component
const PermissionRequest = ({ onPermissionGranted }) => {
  const requestPhotoPermission = async () => {
    try {
      if (Platform.OS === 'ios') {
        const result = await request(PERMISSIONS.IOS.PHOTO_LIBRARY);
        if (result === RESULTS.GRANTED) {
          onPermissionGranted();
        } else {
          Alert.alert(
            'Permission Required',
            'This app needs access to your photo library to display your photos. Please enable it in Settings.',
            [
              { text: 'Cancel', style: 'cancel' },
              { text: 'Settings', onPress: () => {} }
            ]
          );
        }
      } else {
        const granted = await PermissionsAndroid.request(
          PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE,
          {
            title: 'Photo Permission',
            message: 'This app needs access to your photos to display them.',
            buttonNeutral: 'Ask Me Later',
            buttonNegative: 'Cancel',
            buttonPositive: 'OK',
          }
        );
        if (granted === PermissionsAndroid.RESULTS.GRANTED) {
          onPermissionGranted();
        }
      }
    } catch (err) {
      console.warn(err);
    }
  };

  return (
    <SafeAreaView style={styles.permissionContainer}>
      <View style={styles.permissionContent}>
        <Icon name="photo-library" size={80} color="#007AFF" />
        <Text style={styles.permissionTitle}>Photo Access</Text>
        <Text style={styles.permissionMessage}>
          This app needs access to your photo library to display and manage your photos, just like Google Photos.
        </Text>
        <TouchableOpacity style={styles.permissionButton} onPress={requestPhotoPermission}>
          <Text style={styles.permissionButtonText}>Allow Access</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

// Photo Detail Screen Component
const PhotoDetailScreen = ({ route, navigation }) => {
  const { photo } = route.params;

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.detailHeader}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Icon name="arrow-back" size={24} color="#007AFF" />
        </TouchableOpacity>
        <View style={styles.headerActions}>
          <TouchableOpacity style={styles.actionButton}>
            <Icon name="favorite-border" size={24} color="#007AFF" />
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionButton}>
            <Icon name="share" size={24} color="#007AFF" />
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionButton}>
            <Icon name="more-vert" size={24} color="#007AFF" />
          </TouchableOpacity>
        </View>
      </View>
      
      <ScrollView style={styles.detailScrollView}>
        <Image source={{ uri: photo.uri }} style={styles.detailImage} />
        
        <View style={styles.photoInfo}>
          <Text style={styles.photoDate}>{photo.date}</Text>
          <Text style={styles.photoLocation}>San Francisco, CA</Text>
          
          <View style={styles.photoActions}>
            <TouchableOpacity style={styles.photoActionButton}>
              <Icon name="edit" size={20} color="#007AFF" />
              <Text style={styles.photoActionText}>Edit</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.photoActionButton}>
              <Icon name="crop" size={20} color="#007AFF" />
              <Text style={styles.photoActionText}>Crop</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.photoActionButton}>
              <Icon name="filter" size={20} color="#007AFF" />
              <Text style={styles.photoActionText}>Filter</Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Memory Detail Screen Component
const MemoryDetailScreen = ({ route, navigation }) => {
  const { memory } = route.params;

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.detailHeader}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Icon name="arrow-back" size={24} color="#007AFF" />
        </TouchableOpacity>
        <Text style={styles.detailHeaderTitle}>Memory</Text>
        <TouchableOpacity style={styles.actionButton}>
          <Icon name="share" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>
      
      <ScrollView style={styles.detailScrollView}>
        <View style={styles.memoryDetailCard}>
          <Image source={{ uri: memory.uri }} style={styles.memoryDetailImage} />
          <View style={styles.memoryDetailOverlay}>
            <Text style={styles.memoryDetailTitle}>{memory.title}</Text>
            <Text style={styles.memoryDetailSubtitle}>{memory.subtitle}</Text>
          </View>
        </View>
        
        <View style={styles.memoryPhotos}>
          <Text style={styles.sectionTitle}>Photos from this memory</Text>
          <View style={styles.memoryPhotosGrid}>
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <TouchableOpacity key={i} style={styles.memoryPhotoItem}>
                <Image source={{ uri: `https://picsum.photos/300/300?random=${20 + i}` }} style={styles.memoryPhoto} />
              </TouchableOpacity>
            ))}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Album Detail Screen Component
const AlbumDetailScreen = ({ route, navigation }) => {
  const { album } = route.params;

  const albumPhotos = Array.from({ length: 15 }, (_, i) => ({
    id: i + 1,
    uri: `https://picsum.photos/300/300?random=${30 + i}`,
  }));

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.detailHeader}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Icon name="arrow-back" size={24} color="#007AFF" />
        </TouchableOpacity>
        <Text style={styles.detailHeaderTitle}>{album.title}</Text>
        <TouchableOpacity style={styles.actionButton}>
          <Icon name="more-vert" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>
      
      <View style={styles.albumInfo}>
        <Text style={styles.albumDetailCount}>{album.count} photos</Text>
        <View style={styles.albumActions}>
          <TouchableOpacity style={styles.albumActionButton}>
            <Icon name="play-arrow" size={20} color="#007AFF" />
            <Text style={styles.albumActionText}>Slideshow</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.albumActionButton}>
            <Icon name="select-all" size={20} color="#007AFF" />
            <Text style={styles.albumActionText}>Select</Text>
          </TouchableOpacity>
        </View>
      </View>
      
      <ScrollView style={styles.detailScrollView}>
        <View style={styles.albumPhotosGrid}>
          {albumPhotos.map((photo) => (
            <TouchableOpacity key={photo.id} style={styles.albumPhotoContainer}>
              <Image source={{ uri: photo.uri }} style={styles.albumPhoto} />
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Search Results Screen Component
const SearchResultsScreen = ({ route, navigation }) => {
  const { category } = route.params;

  const searchResults = {
    People: [
      { id: 1, name: 'John Doe', photo: 'https://picsum.photos/300/300?random=50', count: '23 photos' },
      { id: 2, name: 'Jane Smith', photo: 'https://picsum.photos/300/300?random=51', count: '15 photos' },
      { id: 3, name: 'Mike Johnson', photo: 'https://picsum.photos/300/300?random=52', count: '8 photos' },
    ],
    Places: [
      { id: 1, name: 'San Francisco', photo: 'https://picsum.photos/300/300?random=53', count: '45 photos' },
      { id: 2, name: 'New York', photo: 'https://picsum.photos/300/300?random=54', count: '32 photos' },
      { id: 3, name: 'Paris', photo: 'https://picsum.photos/300/300?random=55', count: '18 photos' },
    ],
    Things: [
      { id: 1, name: 'Food', photo: 'https://picsum.photos/300/300?random=56', count: '67 photos' },
      { id: 2, name: 'Nature', photo: 'https://picsum.photos/300/300?random=57', count: '89 photos' },
      { id: 3, name: 'Architecture', photo: 'https://picsum.photos/300/300?random=58', count: '34 photos' },
    ],
    Videos: [
      { id: 1, name: 'Vacation 2023', photo: 'https://picsum.photos/300/300?random=59', duration: '2:34' },
      { id: 2, name: 'Birthday Party', photo: 'https://picsum.photos/300/300?random=60', duration: '1:45' },
      { id: 3, name: 'Concert', photo: 'https://picsum.photos/300/300?random=61', duration: '3:12' },
    ],
  };

  const results = searchResults[category] || [];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.detailHeader}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Icon name="arrow-back" size={24} color="#007AFF" />
        </TouchableOpacity>
        <Text style={styles.detailHeaderTitle}>{category}</Text>
        <TouchableOpacity style={styles.actionButton}>
          <Icon name="search" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>
      
      <ScrollView style={styles.detailScrollView}>
        <View style={styles.searchResultsList}>
          {results.map((result) => (
            <TouchableOpacity key={result.id} style={styles.searchResultItem}>
              <Image source={{ uri: result.photo }} style={styles.searchResultImage} />
              <View style={styles.searchResultInfo}>
                <Text style={styles.searchResultTitle}>{result.name}</Text>
                <Text style={styles.searchResultSubtitle}>
                  {result.count || `${result.duration} video`}
                </Text>
              </View>
              <Icon name="chevron-right" size={24} color="#C7C7CC" />
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Library Detail Screen Component
const LibraryDetailScreen = ({ route, navigation }) => {
  const { item } = route.params;

  const libraryContent = {
    'Recently Deleted': {
      photos: [],
      message: 'No recently deleted items',
      icon: 'delete-outline',
    },
    'Hidden': {
      photos: [],
      message: 'No hidden items',
      icon: 'visibility-off',
    },
    'Imports': {
      photos: [
        { id: 1, uri: 'https://picsum.photos/300/300?random=70', date: '2023-12-01' },
        { id: 2, uri: 'https://picsum.photos/300/300?random=71', date: '2023-11-28' },
      ],
      message: 'No imported items',
      icon: 'file-download',
    },
  };

  const content = libraryContent[item.title] || libraryContent['Recently Deleted'];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.detailHeader}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Icon name="arrow-back" size={24} color="#007AFF" />
        </TouchableOpacity>
        <Text style={styles.detailHeaderTitle}>{item.title}</Text>
        <TouchableOpacity style={styles.actionButton}>
          <Icon name="more-vert" size={24} color="#007AFF" />
        </TouchableOpacity>
      </View>
      
      <ScrollView style={styles.detailScrollView}>
        {content.photos.length > 0 ? (
          <View style={styles.libraryPhotosGrid}>
            {content.photos.map((photo) => (
              <TouchableOpacity key={photo.id} style={styles.libraryPhotoContainer}>
                <Image source={{ uri: photo.uri }} style={styles.libraryPhoto} />
                <Text style={styles.libraryPhotoDate}>{photo.date}</Text>
              </TouchableOpacity>
            ))}
          </View>
        ) : (
          <View style={styles.emptyLibraryState}>
            <Icon name={content.icon} size={64} color="#C7C7CC" />
            <Text style={styles.emptyLibraryMessage}>{content.message}</Text>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
};

// Photos Screen Component
const PhotosScreen = ({ navigation }) => {
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
                <TouchableOpacity 
                  key={photo.id} 
                  style={styles.photoContainer}
                  onPress={() => navigation.navigate('PhotoDetail', { photo })}
                >
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
const ForYouScreen = ({ navigation }) => {
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
            <TouchableOpacity 
              key={memory.id} 
              style={styles.memoryCard}
              onPress={() => navigation.navigate('MemoryDetail', { memory })}
            >
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
const AlbumsScreen = ({ navigation }) => {
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
            <TouchableOpacity 
              key={album.id} 
              style={styles.albumContainer}
              onPress={() => navigation.navigate('AlbumDetail', { album })}
            >
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
const SearchScreen = ({ navigation }) => {
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
            <TouchableOpacity 
              key={category.id} 
              style={styles.categoryCard}
              onPress={() => navigation.navigate('SearchResults', { category: category.title })}
            >
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
const LibraryScreen = ({ navigation }) => {
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
            <TouchableOpacity 
              key={item.id} 
              style={styles.libraryItem}
              onPress={() => navigation.navigate('LibraryDetail', { item })}
            >
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

// Stack Navigator for Photos Tab
const PhotosStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="PhotosMain" component={PhotosScreen} />
      <Stack.Screen name="PhotoDetail" component={PhotoDetailScreen} />
    </Stack.Navigator>
  );
};

// Stack Navigator for For You Tab
const ForYouStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="ForYouMain" component={ForYouScreen} />
      <Stack.Screen name="MemoryDetail" component={MemoryDetailScreen} />
    </Stack.Navigator>
  );
};

// Stack Navigator for Albums Tab
const AlbumsStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="AlbumsMain" component={AlbumsScreen} />
      <Stack.Screen name="AlbumDetail" component={AlbumDetailScreen} />
    </Stack.Navigator>
  );
};

// Stack Navigator for Search Tab
const SearchStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="SearchMain" component={SearchScreen} />
      <Stack.Screen name="SearchResults" component={SearchResultsScreen} />
    </Stack.Navigator>
  );
};

// Stack Navigator for Library Tab
const LibraryStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="LibraryMain" component={LibraryScreen} />
      <Stack.Screen name="LibraryDetail" component={LibraryDetailScreen} />
    </Stack.Navigator>
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
      <Tab.Screen name="Photos" component={PhotosStack} />
      <Tab.Screen name="For You" component={ForYouStack} />
      <Tab.Screen name="Albums" component={AlbumsStack} />
      <Tab.Screen name="Search" component={SearchStack} />
      <Tab.Screen name="Library" component={LibraryStack} />
    </Tab.Navigator>
  );
};

function App() {
  const isDarkMode = useColorScheme() === 'dark';
  const [hasPermission, setHasPermission] = useState(false);

  useEffect(() => {
    checkPhotoPermission();
  }, []);

  const checkPhotoPermission = async () => {
    try {
      if (Platform.OS === 'ios') {
        const result = await check(PERMISSIONS.IOS.PHOTO_LIBRARY);
        setHasPermission(result === RESULTS.GRANTED);
      } else {
        const result = await check(PERMISSIONS.ANDROID.READ_EXTERNAL_STORAGE);
        setHasPermission(result === RESULTS.GRANTED);
      }
    } catch (err) {
      console.warn(err);
    }
  };

  const handlePermissionGranted = () => {
    setHasPermission(true);
  };

  if (!hasPermission) {
    return <PermissionRequest onPermissionGranted={handlePermissionGranted} />;
  }

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
  // Permission Request Styles
  permissionContainer: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 32,
  },
  permissionContent: {
    alignItems: 'center',
    maxWidth: 300,
  },
  permissionTitle: {
    fontSize: 24,
    fontWeight: '700',
    color: '#000000',
    marginTop: 24,
    marginBottom: 16,
    textAlign: 'center',
  },
  permissionMessage: {
    fontSize: 16,
    color: '#8E8E93',
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: 32,
  },
  permissionButton: {
    backgroundColor: '#007AFF',
    paddingHorizontal: 32,
    paddingVertical: 16,
    borderRadius: 12,
  },
  permissionButtonText: {
    color: '#FFFFFF',
    fontSize: 17,
    fontWeight: '600',
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
  // Detail Screen Styles
  detailHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  detailHeaderTitle: {
    fontSize: 17,
    fontWeight: '600',
    color: '#000000',
  },
  backButton: {
    padding: 8,
  },
  headerActions: {
    flexDirection: 'row',
  },
  actionButton: {
    padding: 8,
    marginLeft: 8,
  },
  detailScrollView: {
    flex: 1,
  },
  detailImage: {
    width: width,
    height: width,
    resizeMode: 'cover',
  },
  photoInfo: {
    padding: 16,
  },
  photoDate: {
    fontSize: 17,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  photoLocation: {
    fontSize: 15,
    color: '#8E8E93',
    marginBottom: 16,
  },
  photoActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  photoActionButton: {
    alignItems: 'center',
    padding: 12,
  },
  photoActionText: {
    fontSize: 12,
    color: '#007AFF',
    marginTop: 4,
  },
  memoryDetailCard: {
    height: 300,
    borderRadius: 12,
    margin: 16,
    overflow: 'hidden',
  },
  memoryDetailImage: {
    width: '100%',
    height: '100%',
  },
  memoryDetailOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    padding: 16,
  },
  memoryDetailTitle: {
    fontSize: 24,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  memoryDetailSubtitle: {
    fontSize: 16,
    color: '#FFFFFF',
    opacity: 0.8,
  },
  memoryPhotos: {
    paddingHorizontal: 16,
  },
  memoryPhotosGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginTop: 16,
  },
  memoryPhotoItem: {
    width: '33.33%',
    aspectRatio: 1,
    padding: 1,
  },
  memoryPhoto: {
    flex: 1,
    borderRadius: 8,
  },
  albumInfo: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  albumDetailCount: {
    fontSize: 15,
    color: '#8E8E93',
    marginBottom: 12,
  },
  albumActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  albumActionButton: {
    alignItems: 'center',
    padding: 8,
  },
  albumActionText: {
    fontSize: 12,
    color: '#007AFF',
    marginTop: 4,
  },
  albumPhotosGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
  },
  albumPhotoContainer: {
    width: '33.33%',
    aspectRatio: 1,
    padding: 1,
  },
  albumPhoto: {
    flex: 1,
    borderRadius: 8,
  },
  searchResultsList: {
    paddingHorizontal: 16,
  },
  searchResultItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 16,
    borderBottomWidth: 0.5,
    borderBottomColor: '#C7C7CC',
  },
  searchResultImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    marginRight: 16,
  },
  searchResultInfo: {
    flex: 1,
  },
  searchResultTitle: {
    fontSize: 17,
    fontWeight: '500',
    color: '#000000',
  },
  searchResultSubtitle: {
    fontSize: 15,
    color: '#8E8E93',
    marginTop: 2,
  },
  libraryPhotosGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
  },
  libraryPhotoContainer: {
    width: '50%',
    aspectRatio: 1,
    padding: 1,
  },
  libraryPhoto: {
    flex: 1,
    borderRadius: 8,
  },
  libraryPhotoDate: {
    fontSize: 12,
    color: '#8E8E93',
    textAlign: 'center',
    marginTop: 4,
  },
  emptyLibraryState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 64,
  },
  emptyLibraryMessage: {
    fontSize: 17,
    color: '#8E8E93',
    marginTop: 16,
  },
});

export default App;
