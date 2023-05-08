import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/utils.dart';
import 'package:about/about_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_search_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/tv_popular_cubit.dart';
import 'package:tv/presentation/bloc/tv_search_cubit.dart';
import 'package:tv/presentation/bloc/tv_top_rated_cubit.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:movie/presentation/pages/search_movie_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:watchlist/presentation/bloc/watchlist_cubit.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: BlocProvider<MovieHomeCubit>(
          create: (_) => di.locator(),
          child: HomeMoviePage(),
        ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => BlocProvider<MovieHomeCubit>(
                    create: (_) => di.locator(),
                    child: HomeMoviePage(),
                  )
              );
            case HomeTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => BlocProvider<TVListCubit>(
                  create: (_) => di.locator(),
                  child: HomeTVPage()
                )
              );
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<MoviePopularCubit>(
                  create: (_) => di.locator(),
                  child: PopularMoviesPage()
                )
              );
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<TVPopularCubit>(
                  create: (_) => di.locator(),
                  child: PopularTvsPage()
                )
              );
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<MovieTopRatedCubit>(
                  create: (_) => di.locator(),
                  child: TopRatedMoviesPage(),
                )
              );
            case TopRatedTVsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<TVTopRatedCubit>(
                  create: (_) => di.locator(),
                  child: TopRatedTVsPage()
                )
              );
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => BlocProvider<MovieDetailCubit>(
                    create: (_) => di.locator(),
                    child: MovieDetailPage(id: id)
                )
              );
            case TVDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => BlocProvider<TVDetailCubit>(
                  create: (_) => di.locator(),
                  child: TVDetailPage(id: id),
                ),
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<MovieSearchCubit>(
                  create: (_) => di.locator(),
                  child: SearchMoviePage()
                )
              );
            case SearchTVPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => BlocProvider<TVSearchCubit>(
                  create: (_) => di.locator(),
                  child: SearchTVPage()
                )
              );
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => BlocProvider<WatchlistCubit>(
                  create: (_) => di.locator(),
                  child: WatchlistPage()
                )
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}