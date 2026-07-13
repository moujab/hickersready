package com.hikersway.backend.config;

import com.hikersway.backend.entity.Contributor;
import com.hikersway.backend.entity.Guide;
import com.hikersway.backend.entity.Invitation;
import com.hikersway.backend.entity.Town;
import com.hikersway.backend.entity.UpcomingHike;
import com.hikersway.backend.repository.ContributorRepository;
import com.hikersway.backend.repository.GuideRepository;
import com.hikersway.backend.repository.InvitationRepository;
import com.hikersway.backend.repository.TownRepository;
import com.hikersway.backend.repository.UpcomingHikeRepository;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/** Same sample Arabic seed data the app used to ship via mock_data.dart, now server-side. */
@Component
public class DataSeeder implements CommandLineRunner {

    private final InvitationRepository invitations;
    private final TownRepository towns;
    private final GuideRepository guides;
    private final ContributorRepository contributors;
    private final UpcomingHikeRepository upcomingHikes;

    public DataSeeder(InvitationRepository invitations, TownRepository towns, GuideRepository guides,
            ContributorRepository contributors, UpcomingHikeRepository upcomingHikes) {
        this.invitations = invitations;
        this.towns = towns;
        this.guides = guides;
        this.contributors = contributors;
        this.upcomingHikes = upcomingHikes;
    }

    @Override
    public void run(String... args) {
        if (invitations.count() == 0) {
            invitations.saveAll(List.of(
                    new Invitation("1", "جبل الشيخ", LocalDateTime.of(2026, 5, 2, 0, 0),
                            "دعوة للمشاركة في رحلة صعود جبل الشيخ، يوم السبت الساعة السابعة صباحاً. يرجى إحضار الماء ولباس مناسب."),
                    new Invitation("2", "وادي قاديشا", LocalDateTime.of(2026, 4, 10, 0, 0),
                            "رحلة إلى وادي قاديشا مع زيارة الأديرة التاريخية في الوادي.")));
        }

        if (towns.count() == 0) {
            towns.saveAll(List.of(
                    new Town("1", "بشري", "بلدة جبلية تشتهر بأرزها القديم ومسقط رأس الشاعر جبران خليل جبران."),
                    new Town("2", "دوما", "قرية تراثية تشتهر ببيوتها الحجرية القديمة وأزقتها الضيقة.")));
        }

        if (guides.count() == 0) {
            guides.saveAll(List.of(
                    new Guide("1", "أحمد خليل", "مرشد جبلي معتمد لديه أكثر من عشر سنوات خبرة في تسلق الجبال."),
                    new Guide("2", "سارة منصور", "مرشدة متخصصة في مسارات الطبيعة والتعريف بالنباتات المحلية.")));
        }

        if (contributors.count() == 0) {
            contributors.saveAll(List.of(
                    new Contributor("1", "مطعم الجبل", "طعام", "مطعم محلي يقدم الأطباق التقليدية اللبنانية للمتنزهين.",
                            "+961 00 000 000", List.of()),
                    new Contributor("2", "متجر معدات المشي", "تجهيزات", "متجر متخصص ببيع معدات المشي والتخييم.",
                            "+961 00 111 111", List.of())));
        }

        if (upcomingHikes.count() == 0) {
            upcomingHikes.saveAll(List.of(
                    new UpcomingHike("1", "تنورين", LocalDateTime.of(2026, 8, 15, 0, 0),
                            "رحلة قادمة إلى غابة أرز تنورين، مستوى الصعوبة متوسط."),
                    new UpcomingHike("2", "أرز الشوف", LocalDateTime.of(2026, 9, 1, 0, 0),
                            "رحلة إلى محمية أرز الشوف، تشمل مشاهدة الطبيعة والتصوير.")));
        }
    }
}
