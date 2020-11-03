import 'dart:ui';

import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Feeling {
  /// The name of this feeling
  String name;

  /// An emoji associated with this feeling
  Emoji emoji;

  /// A color associated with this feeling
  Color color;

  /// Possibly null "parent" Feeling that's more general than this Feeling
  Feeling parent;

  /// Possibly null "child" Feelings that are more specific than this Feeling
  List<Feeling> children;

  Feeling(this.name, this.emoji, {Feeling parent, Color color}) {
    if ((parent == null) == (color == null)) {
      throw ArgumentError(
          "Expected exactly one of parent or color to be non-null!");
    } else if (color != null) {
      this.color = color;
    } else {
      this.color = parent.color;
      this.parent = parent;

      if (parent.children == null) {
        parent.children = [];
      }

      parent.children.add(this);
    }
  }

  /// From Geoffrey Roberts:
  ///
  /// "I work with people who have limited emotional vocabulary and as a result
  /// the intensity of their negative emotions and experiences is heightened
  /// because they can't describe their feelings (especially their
  /// negative feelings). That's why this list is heavily focused on negative
  /// emotions/ experiences. Being able to clearly identify how we are feeling
  /// has been shown to reduce this intensity of experience because it
  /// re-engages our rational mind.
  ///
  /// I believe the first application of an emotion wheel in this style was from
  /// Dr. Gloria Willcox back in the early 80’s. The wheel I put together is
  /// much more comprehensive than her original wheel although I suspect she had
  /// a more studious approach. It’s possible the wheel I originally based mine
  /// on was created by a teacher named Kaitlin Robb, although I think her wheel
  /// is also an updated version of the earlier one I found circulating the
  /// internet."
  ///
  /// I personally find the feeling wheel extremely useful, although I'm not
  /// sure this is the version I normally use -- either way, the purpose is
  /// the same, and this one is very thorough.
  static List<Feeling> wheel() {
    // https://xg5cag.ch.files.1drv.com/y4mB6mk4VZHmThHKgiEHnVSzz3E0nNQO28Kgx6FxYI1IsFn4O5pugwsISmlwc26QshghBt7Mc1eE8A5CpoJBWgVlucy-zKES226A7Xngrto7T1XhKc0oFqqyYD1Tkwwh2scftk9wrWVubIugIE21hE0Ylc9wXxVy2mBnvLhIcqL-EKj0nlDJHrpSDC--AgaX3FYongSgt9to2F-XSTp73a8Ng/Emotion-Wheel-Color.jpg?psid=1
    // Credit to Geoffrey Roberts

    return [
      Feeling._fearful(),
      Feeling._angry(),
      Feeling._disgusted(),
      Feeling._sad(),
      Feeling._happy(),
      Feeling._surprised(),
      Feeling._bad()
    ];
  }

  static Feeling _fearful() {
    /* 
     * "fearful" feelings
     */
    var fearful = Feeling('Fearful', Emoji.byChar(Emojis.fearfulFace),
        color: Color(0xFFFFDF85));

    // scared --> helpless, frightened
    var scared =
        Feeling('Scared', Emoji.byChar(Emojis.fearfulFace), parent: fearful);
    Feeling('Helpless', Emoji.byChar(Emojis.baby), parent: scared);
    Feeling('Frightened', Emoji.byChar(Emojis.faceScreamingInFear),
        parent: scared);

    // anxious --> overwhelmed, worried
    var anxious = Feeling('Anxious', Emoji.byChar(Emojis.anxiousFaceWithSweat),
        parent: fearful);
    Feeling('Overwhelmed', Emoji.byChar(Emojis.slightlySmilingFace),
        parent: anxious);
    Feeling('Worried', Emoji.byChar(Emojis.worriedFace), parent: anxious);

    // insecure --> inadequate, inferior
    var insecure = Feeling('Insecure', Emoji.byChar(Emojis.faceWithoutMouth),
        parent: fearful);
    Feeling('Inadequate', Emoji.byChar(Emojis.pensiveFace), parent: insecure);
    Feeling('Inferior', Emoji.byChar(Emojis.frowningFace), parent: insecure);

    // weak --> worthless, insignificant
    var weak = Feeling('Weak', Emoji.byChar(Emojis.mouse), parent: fearful);
    Feeling('Worthless', Emoji.byChar(Emojis.wastebasket), parent: weak);
    Feeling('Insignificant', Emoji.byChar(Emojis.pinchingHand), parent: weak);

    // rejected --> excluded, persecuted
    var rejected = Feeling('Rejected', Emoji.byChar(Emojis.disappointedFace),
        parent: fearful);
    Feeling('Excluded', Emoji.byChar(Emojis.bustsInSilhouette),
        parent: rejected);
    Feeling('Persecuted', Emoji.byChar(Emojis.nerdFace), parent: rejected);

    // threatened --> nervous, exposed
    var threatened = Feeling('Threatened', Emoji.byChar(Emojis.anguishedFace),
        parent: fearful);
    Feeling('Nervous', Emoji.byChar(Emojis.nauseatedFace), parent: threatened);
    Feeling('Exposed', Emoji.byChar(Emojis.eyes), parent: threatened);

    return fearful;
  }

  static Feeling _angry() {
    /* 
     * "angry" feelings
     */
    var angry = Feeling('Angry', Emoji.byChar(Emojis.angryFace),
        color: Color(0xFFFF7F7E));

    // let down --> betrayed, resentful
    var letDown = Feeling('Let Down', Emoji.byChar(Emojis.slightlyFrowningFace),
        parent: angry);
    Feeling('Betrayed', Emoji.byChar(Emojis.frowningFaceWithOpenMouth),
        parent: letDown);
    Feeling('Resentful', Emoji.byChar(Emojis.angryFace), parent: letDown);

    // humiliated --> disrespected, ridiculed
    var humiliated =
        Feeling('Humiliated', Emoji.byChar(Emojis.clownFace), parent: angry);
    Feeling('Disrespected', Emoji.byChar(Emojis.middleFinger),
        parent: humiliated);
    Feeling('Ridiculed', Emoji.byChar(Emojis.confoundedFace),
        parent: humiliated);

    // bitter --> indignant, violated
    var bitter =
        Feeling('Bitter', Emoji.byChar(Emojis.unamusedFace), parent: angry);
    Feeling('Indignant', Emoji.byChar(Emojis.angryFace), parent: bitter);
    Feeling('Violated', Emoji.byChar(Emojis.poutingFace), parent: bitter);

    // mad --> furious, jealous
    var mad = Feeling('Mad', Emoji.byChar(Emojis.poutingFace), parent: angry);
    Feeling('Furious', Emoji.byChar(Emojis.faceWithSymbolsOnMouth),
        parent: mad);
    Feeling('Jealous', Emoji.byChar(Emojis.unamusedFace), parent: mad);

    // aggressive --> provoked, hostile
    var aggressive = Feeling(
        'Aggressive', Emoji.byChar(Emojis.angryFaceWithHorns),
        parent: angry);
    Feeling('Provoked', Emoji.byChar(Emojis.firecracker), parent: aggressive);
    Feeling('Hostile', Emoji.byChar(Emojis.kitchenKnife), parent: aggressive);

    // frustrated --> infuriated, annoyed
    var frustrated = Feeling(
        'Frustrated', Emoji.byChar(Emojis.faceWithSteamFromNose),
        parent: angry);
    Feeling('Infuriated', Emoji.byChar(Emojis.confoundedFace),
        parent: frustrated);
    Feeling('Annoyed', Emoji.byChar(Emojis.confusedFace), parent: frustrated);

    // distant --> withdrawn, numb
    var distant = Feeling('Distant', Emoji.byChar(Emojis.bustInSilhouette),
        parent: angry);
    Feeling('Withdrawn', Emoji.byChar(Emojis.zipperMouthFace), parent: distant);
    Feeling('Numb', Emoji.byChar(Emojis.neutralFace), parent: distant);

    // critical --> skeptical, dismissive
    var critical = Feeling(
        'Critical', Emoji.byChar(Emojis.faceWithRaisedEyebrow),
        parent: angry);
    Feeling('Skeptical', Emoji.byChar(Emojis.faceWithMonocle),
        parent: critical);
    Feeling('Dismissive', Emoji.byChar(Emojis.faceWithRollingEyes),
        parent: critical);

    return angry;
  }

  static Feeling _disgusted() {
    /* 
     * "disgusted" feelings
     */
    var disgusted = Feeling('Disgusted', Emoji.byChar(Emojis.nauseatedFace),
        color: Color(0xFF808080));

    // disapproving --> judgemental, embarassed
    var disapproving = Feeling(
        'Disapproving', Emoji.byChar(Emojis.frowningFace),
        parent: disgusted);
    Feeling('Judgemental', Emoji.byChar(Emojis.confusedFace),
        parent: disapproving);
    Feeling('Embarassed', Emoji.byChar(Emojis.flushedFace),
        parent: disapproving);

    // disappointed --> appalled, revolted
    var disappointed = Feeling(
        'Disappointed', Emoji.byChar(Emojis.disappointedFace),
        parent: disgusted);
    Feeling('Appalled', Emoji.byChar(Emojis.frowningFaceWithOpenMouth),
        parent: disappointed);
    Feeling('Revolted', Emoji.byChar(Emojis.faceWithMedicalMask),
        parent: disappointed);

    // awful --> nauseated, detestable
    var awful = Feeling('Awful', Emoji.byChar(Emojis.angryFaceWithHorns),
        parent: disgusted);
    Feeling('Nauseated', Emoji.byChar(Emojis.faceVomiting), parent: awful);
    Feeling('Detestable', Emoji.byChar(Emojis.downcastFaceWithSweat),
        parent: awful);

    // repelled --> horrified, hesitant
    var repelled = Feeling('Repelled', Emoji.byChar(Emojis.grimacingFace),
        parent: disgusted);
    Feeling('Horrified', Emoji.byChar(Emojis.anguishedFace), parent: repelled);
    Feeling('Hesitant', Emoji.byChar(Emojis.confusedFace), parent: repelled);

    return disgusted;
  }

  static Feeling _sad() {
    /* 
     * "sad" feelings
     */
    var sad = Feeling('Sad', Emoji.byChar(Emojis.pensiveFace),
        color: Color(0xFF80B7DE));

    // hurt --> embarassed, disappointed
    var hurt =
        Feeling('Hurt', Emoji.byChar(Emojis.faceWithHeadBandage), parent: sad);
    Feeling('Embarassed', Emoji.byChar(Emojis.flushedFace), parent: hurt);
    Feeling('Disappointed', Emoji.byChar(Emojis.disappointedFace),
        parent: hurt);

    // depressed --> inferior, empty
    var depressed =
        Feeling('Depressed', Emoji.byChar(Emojis.pensiveFace), parent: sad);
    Feeling('Inferior', Emoji.byChar(Emojis.downcastFaceWithSweat),
        parent: depressed);
    Feeling('Empty', Emoji.byChar(Emojis.package), parent: depressed);

    // guilty --> remorseful, ashamed
    var guilty =
        Feeling('Guilty', Emoji.byChar(Emojis.pensiveFace), parent: sad);
    Feeling('Remorseful', Emoji.byChar(Emojis.sadButRelievedFace),
        parent: guilty);
    Feeling('Ashamed', Emoji.byChar(Emojis.perseveringFace), parent: guilty);

    // despair --> powerless, grief
    var despair = Feeling('Despair', Emoji.byChar(Emojis.anxiousFaceWithSweat),
        parent: sad);
    Feeling('Powerless', Emoji.byChar(Emojis.cryingFace), parent: despair);
    Feeling('Grief', Emoji.byChar(Emojis.disappointedFace), parent: despair);

    // vulnerable --> fragile, victimized
    var vulnerable =
        Feeling('Vulnerable', Emoji.byChar(Emojis.pleadingFace), parent: sad);
    Feeling('Fragile', Emoji.byChar(Emojis.brokenHeart), parent: vulnerable);
    Feeling('Victimized', Emoji.byChar(Emojis.confoundedFace),
        parent: vulnerable);

    // lonely --> isolated, abandoned
    var lonely = Feeling('Lonely', Emoji.byChar(Emojis.slightlyFrowningFace),
        parent: sad);
    Feeling('Isolated', Emoji.byChar(Emojis.faceWithoutMouth), parent: lonely);
    Feeling('Abandoned', Emoji.byChar(Emojis.cryingFace), parent: lonely);

    return sad;
  }

  static Feeling _happy() {
    /* 
     * "happy" feelings
     */
    var happy = Feeling(
        'Happy', Emoji.byChar(Emojis.smilingFaceWithSmilingEyes),
        color: Color(0xFFFEFF7F));

    // optimistic --> inspired, hopeful
    var optimistic = Feeling(
        'Optimistic', Emoji.byChar(Emojis.grinningFaceWithSmilingEyes),
        parent: happy);
    Feeling('Inspired', Emoji.byChar(Emojis.starStruck), parent: optimistic);
    Feeling('Hopeful', Emoji.byChar(Emojis.smilingFace), parent: optimistic);

    // trusting --> intimate, sensitive
    var trusting = Feeling(
        'Trusting', Emoji.byChar(Emojis.kissingFaceWithClosedEyes),
        parent: happy);
    Feeling('Intimate', Emoji.byChar(Emojis.peopleHoldingHands),
        parent: trusting);
    Feeling('Sensitive', Emoji.byChar(Emojis.pleadingFace), parent: trusting);

    // peaceful --> loving, thankful
    var peaceful =
        Feeling('Peaceful', Emoji.byChar(Emojis.relievedFace), parent: happy);
    Feeling('Loving', Emoji.byChar(Emojis.smilingFaceWithHearts),
        parent: peaceful);
    Feeling('Thankful', Emoji.byChar(Emojis.relievedFace), parent: peaceful);

    // powerful --> courageous, creative
    var powerful = Feeling(
        'Powerful', Emoji.byChar(Emojis.smilingFaceWithHorns),
        parent: happy);
    Feeling('Courageous', Emoji.byChar(Emojis.lion), parent: powerful);
    Feeling('Creative', Emoji.byChar(Emojis.artistPalette), parent: powerful);

    // accepted --> respected, valued
    var accepted =
        Feeling('Accepted', Emoji.byChar(Emojis.family), parent: happy);
    Feeling('Respected', Emoji.byChar(Emojis.smilingFaceWithHalo),
        parent: accepted);
    Feeling('Valued', Emoji.byChar(Emojis.huggingFace), parent: accepted);

    // proud --> successful, confident
    var proud = Feeling(
        'Proud', Emoji.byChar(Emojis.beamingFaceWithSmilingEyes),
        parent: happy);
    Feeling('Successful', Emoji.byChar(Emojis.grinningFaceWithBigEyes),
        parent: proud);
    Feeling('Confident', Emoji.byChar(Emojis.smilingFaceWithSunglasses),
        parent: proud);

    // interested --> inquisitive, curious
    var interested =
        Feeling('Interested', Emoji.byChar(Emojis.eyes), parent: happy);
    Feeling('Inquisitive', Emoji.byChar(Emojis.faceWithMonocle),
        parent: interested);
    Feeling('Curious', Emoji.byChar(Emojis.thinkingFace), parent: interested);

    // content --> free, joyful
    var content =
        Feeling('Content', Emoji.byChar(Emojis.relievedFace), parent: happy);
    Feeling('Free', Emoji.byChar(Emojis.eagle), parent: content);
    Feeling('Joyful', Emoji.byChar(Emojis.grinningSquintingFace),
        parent: content);

    // playful --> sexy, cheeky
    var playful =
        Feeling('Playful', Emoji.byChar(Emojis.winkingFace), parent: happy);
    Feeling('Sexy', Emoji.byChar(Emojis.droolingFace), parent: playful);
    Feeling('Cheeky', Emoji.byChar(Emojis.smirkingFace), parent: playful);

    return happy;
  }

  static Feeling _surprised() {
    /* 
     * "surprised" feelings
     */
    var surprised = Feeling('Surprised', Emoji.byChar(Emojis.faceWithOpenMouth),
        color: Color(0xFFB598CE));

    // excited --> eager, energetic
    var excited = Feeling(
        'Excited', Emoji.byChar(Emojis.grinningFaceWithBigEyes),
        parent: surprised);
    Feeling('Eager', Emoji.byChar(Emojis.beamingFaceWithSmilingEyes),
        parent: excited);
    Feeling('Energetic', Emoji.byChar(Emojis.personRunning), parent: excited);

    // amazed --> awe, astonished
    var amazed =
        Feeling('Amazed', Emoji.byChar(Emojis.starStruck), parent: surprised);
    Feeling('Awe', Emoji.byChar(Emojis.hushedFace), parent: amazed);
    Feeling('Astonished', Emoji.byChar(Emojis.astonishedFace), parent: amazed);

    // confused --> disillusioned, perplexed
    var confused = Feeling('Confused', Emoji.byChar(Emojis.confusedFace),
        parent: surprised);
    Feeling('Disillusioned', Emoji.byChar(Emojis.unamusedFace),
        parent: confused);
    Feeling('Perplexed', Emoji.byChar(Emojis.slightlyFrowningFace),
        parent: confused);

    // startled --> shocked, dismayed
    var startled = Feeling('Startled', Emoji.byChar(Emojis.faceWithOpenMouth),
        parent: surprised);
    Feeling('Shocked', Emoji.byChar(Emojis.faceScreamingInFear),
        parent: startled);
    Feeling('Dismayed', Emoji.byChar(Emojis.frowningFace), parent: startled);

    return surprised;
  }

  static Feeling _bad() {
    /* 
     * "bad" feelings
     */
    var bad = Feeling('Bad', Emoji.byChar(Emojis.confusedFace),
        color: Color(0xFF7ED7A7));

    // tired --> sleepy, unfocused
    var tired = Feeling('Tired', Emoji.byChar(Emojis.tiredFace), parent: bad);
    Feeling('Sleepy', Emoji.byChar(Emojis.sleepingFace), parent: tired);
    Feeling('Unfocused', Emoji.byChar(Emojis.upsideDownFace), parent: tired);

    // stressed --> overwhelmed, out of control
    var stressed =
        Feeling('Stressed', Emoji.byChar(Emojis.perseveringFace), parent: bad);
    Feeling('Overwhelmed', Emoji.byChar(Emojis.anxiousFaceWithSweat),
        parent: stressed);
    Feeling('Out of Control', Emoji.byChar(Emojis.dizzyFace), parent: stressed);

    // busy --> pressured, rushed
    var busy = Feeling('Busy', Emoji.byChar(Emojis.personRunning), parent: bad);
    Feeling('Pressured', Emoji.byChar(Emojis.wearyFace), parent: busy);
    Feeling('Rushed', Emoji.byChar(Emojis.confoundedFace), parent: busy);

    // bored --> indifferent, apathetic
    var bored = Feeling('Bored', Emoji.byChar(Emojis.yawningFace), parent: bad);
    Feeling('Indifferent', Emoji.byChar(Emojis.neutralFace), parent: bored);
    Feeling('Apathetic', Emoji.byChar(Emojis.unamusedFace), parent: bored);

    return bad;
  }
}
