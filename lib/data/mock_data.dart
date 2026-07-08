import '../models/contributor.dart';
import '../models/guide.dart';
import '../models/invitation.dart';
import '../models/town.dart';
import '../models/upcoming_hike.dart';

/// Placeholder in-memory data, standing in for the future Spring
/// Boot/MySQL backend.
class MockData {
  static final List<Invitation> invitations = [
    Invitation(
      id: '1',
      trailName: 'جبل الشيخ',
      date: DateTime(2026, 5, 2),
      description: 'دعوة للمشاركة في رحلة صعود جبل الشيخ، يوم السبت الساعة السابعة صباحاً. يرجى إحضار الماء ولباس مناسب.',
    ),
    Invitation(
      id: '2',
      trailName: 'وادي قاديشا',
      date: DateTime(2026, 4, 10),
      description: 'رحلة إلى وادي قاديشا مع زيارة الأديرة التاريخية في الوادي.',
    ),
  ];

  static final List<Town> towns = [
    Town(
      id: '1',
      name: 'بشري',
      description: 'بلدة جبلية تشتهر بأرزها القديم ومسقط رأس الشاعر جبران خليل جبران.',
    ),
    Town(
      id: '2',
      name: 'دوما',
      description: 'قرية تراثية تشتهر ببيوتها الحجرية القديمة وأزقتها الضيقة.',
    ),
  ];

  static final List<Guide> guides = [
    Guide(
      id: '1',
      name: 'أحمد خليل',
      bio: 'مرشد جبلي معتمد لديه أكثر من عشر سنوات خبرة في تسلق الجبال.',
    ),
    Guide(
      id: '2',
      name: 'سارة منصور',
      bio: 'مرشدة متخصصة في مسارات الطبيعة والتعريف بالنباتات المحلية.',
    ),
  ];

  static final List<Contributor> contributors = [
    Contributor(
      id: '1',
      businessName: 'مطعم الجبل',
      category: 'طعام',
      description: 'مطعم محلي يقدم الأطباق التقليدية اللبنانية للمتنزهين.',
      contactPhone: '+961 00 000 000',
    ),
    Contributor(
      id: '2',
      businessName: 'متجر معدات المشي',
      category: 'تجهيزات',
      description: 'متجر متخصص ببيع معدات المشي والتخييم.',
      contactPhone: '+961 00 111 111',
    ),
  ];

  static final List<UpcomingHike> upcomingHikes = [
    UpcomingHike(
      id: '1',
      trailName: 'تنورين',
      date: DateTime(2026, 8, 15),
      description: 'رحلة قادمة إلى غابة أرز تنورين، مستوى الصعوبة متوسط.',
    ),
    UpcomingHike(
      id: '2',
      trailName: 'أرز الشوف',
      date: DateTime(2026, 9, 1),
      description: 'رحلة إلى محمية أرز الشوف، تشمل مشاهدة الطبيعة والتصوير.',
    ),
  ];
}
